<?php

namespace App\Controller\Owner;

use App\Entity\Owner\Email\EmailRecipient;
use App\Entity\Owner\Owner;
use App\Entity\Owner\VendorOrder;
use App\Form\Owner\ContactType;
use App\Form\Owner\MembershipLoginType;
use App\Form\Owner\OwnerType;
use App\Form\Owner\RenewType;
use App\Form\Owner\VendorOrderType;
use App\Manager\MembershipManager;
use App\Service\Mail\Sender;
use App\Service\Payment\PaymentService;
use JMS\Serializer\SerializerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Form\FormError;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Generator\UrlGeneratorInterface;
use Symfony\Contracts\Translation\TranslatorInterface;

class MembershipController extends AbstractController
{
    private $manager;

    private $mailer;

    public function __construct(MembershipManager $manager, Sender $sender)
    {
        $this->manager = $manager;
        $this->mailer = $sender;
    }

    /**
     * @param Request $request
     * @param TranslatorInterface $translator
     * @return \Symfony\Component\HttpFoundation\RedirectResponse|Response
     * @throws \Twig\Error\LoaderError
     * @throws \Twig\Error\RuntimeError
     * @throws \Twig\Error\SyntaxError
     */
    public function login(Request $request, TranslatorInterface $translator)
    {
        $form = $this->createForm(MembershipLoginType::class);
        $form->handleRequest($request);

        if (!$request->isXmlHttpRequest()) {
            if ($form->isSubmitted() && $form->isValid()) {
                $email = $form->getData()['email'];
                $building = isset($form->getData()['building']) ? $this->manager->getBuildingById($form->getData()['building']) : null;
                $owner = $this->manager->findOneByEmail($email, $building);

                if ($owner) {
                    $this->mailer->sendOwnerControl($owner, 'en');

                    return $this->redirectToRoute('membership_access_sent');
                } else {
                    $error = new FormError($translator->trans('sign_up.form.email.not_exists', [], 'validators'));
                    $form->get('email')->addError($error);
                }
            }
        }

        return $this->render('owner/membership/login.html.twig', [
            'form' => $form->createView()
        ]);
    }

    /**
     * @return Response
     */
    public function accessSent()
    {
        return $this->render('owner/membership/access_sent.html.twig');
    }

    /**
     * @param Request $request
     * @param PaymentService $paymentService
     * @param $token
     * @return \Symfony\Component\HttpFoundation\RedirectResponse|Response
     */
    public function signUp(Request $request, PaymentService $paymentService, $token)
    {
        $building = $this->manager->findBuildingByToken($token);

        if ($building) {
            $member = null;

            // Get info about total shares left, and add existed owner to a form(for prevent unique validation)
            $data = $request->request->get('renew');
            $member = $this->manager->getMemberManager()->findOwnerByData($building, $data['member']);

            $sharesLeft = [];

            if (!$member) {
                $member = new Owner();
                $member->setBuilding($building);
            } else {
                $sharesLeft = $this->manager->countPickups($member->getShares());
            }

            $form = $this->createForm(RenewType::class, null, [
                'building' => $building,
                'owner' => $member
            ]);

            $form->handleRequest($request);

            if ($form->isSubmitted() && $form->isValid()) {
                try {
                    $this->manager->saveOwnerData($member, $data);

                    $invoice = $paymentService->ownerPayment($member, $data);

                    // Save view of renewal competed page
                    $this->manager->saveRenewalView($building, $member->getId(), 'Completed');

                    // If invoice is already paid, renew owner
                    if ($invoice->isPaid()) $this->manager->renewMembership($invoice);
                    if (!$invoice->isSent()) $this->mailer->sendOwnerInvoice($invoice);

                    // Show the invoice
                    return $this->redirect($this->generateUrl('membership_renewal_summary', [
                        'id' => $invoice->getId(),
                        'token' => $member->getToken()
                    ]));
                } catch (\Exception $exception) {
                    $formError = new FormError($exception->getMessage(), null, [], null, 'PaymentError');
                    $form->addError($formError);
                }
            }

            return $this->render('owner/membership/sign_up.html.twig', [
                'form' => $form->createView(),
                'country' => $building->getCountry(),
                'sharesLeft' => $sharesLeft
            ]);
        }

        return $this->render('owner/membership/message.html.twig', [
            'message' => 'Page can not be accessed without the building token!'
        ]);
    }

    /**
     * @param Request $request
     * @param $token string
     * @return JsonResponse
     */
    public function checkEmail(Request $request, $token)
    {
        $building = $this->manager->findBuildingByToken($token);
        $member = $this->manager->findOneByEmail($request->query->get('email'), $building);
        $memberData = null;

        if ($member) {
            $memberData = [
                'firstname' => $member->getFirstName(),
                'lastname' => $member->getLastName(),
                'phone' => $member->getPhone()
            ];
        }

        $response = new JsonResponse(['member' => $memberData], 200, array());
        $response->setCallback($request->get('callback'));

        return $response;
    }

    /**
     * @param Request $request
     * @param PaymentService $paymentService
     * @param $token
     * @param EmailRecipient|null $recipient
     * @return \Symfony\Component\HttpFoundation\RedirectResponse|Response
     * @throws \Exception
     */
    public function profile(Request $request, PaymentService $paymentService, $token, EmailRecipient $recipient = null)
    {
        $member = $this->manager->findOneByToken($token);

        if ($member) {
            $form = $this->createForm(OwnerType::class, $member, ['isMembership' => true]);

            $renewForm = $this->createForm(RenewType::class, null, [
                'building' => $member->getBuilding(),
                'owner' => $member
            ]);

            $renewForm->handleRequest($request);

            // s after submission of renewal form in renewal tab
            if ($renewForm->isSubmitted() && $renewForm->isValid()) {
                try {
                    $data = $request->request->get('renew');
                    $this->manager->saveOwnerData($member, $data);
                    $invoice = $paymentService->ownerPayment($member, $data);

                    // Save view of renewal competed page
                    $this->manager->saveRenewalView($member->getBuilding(), $member->getId(), 'Completed');

                    // If invoice is already paid, renew owner
                    if ($invoice->isPaid()) $this->manager->renewMembership($invoice);
                    if (!$invoice->isSent()) $this->mailer->sendOwnerInvoice($invoice);

                    // Redirect to a profile, but with the invoice in renewal tab
                    return $this->redirect($this->generateUrl('membership_profile', [
                        'token' => $token,
                        'invoiceId' => $invoice->getId()
                    ]));
                } catch (\Exception $exception) {
                    $formError = new FormError($exception->getMessage(), null, [], null, 'PaymentError');
                    $renewForm->addError($formError);
                }
            }

            // If owner submitted feedback form -> send feedback message to building
            if (isset($request->request->all()['feedback']) and strlen($request->request->get('feedback')['message']) > 2) {
                $this->mailer->sendFeedback($member, $request->request->get('feedback'));
            }

            // If recipient query parameter given, set recipient link as clicked (link from an email)
            if ($recipient) {
                if (!$recipient->isClicked()) $this->manager->setAsClicked($recipient);

                $query = $request->query->all();

                // If exists feedback parameters
                if (isset($query['shareId']) && isset($query['isSatisfied'])) {
                    // Get share date from feedback email date (feedback dates always 2 days after share date)
                    $feedbackDate = new \DateTime($recipient->getEmailLog()->getCreatedAt()->format('Y-m-d'));
                    $shareDate = $feedbackDate->modify('-2 days')->format('Y-m-d');
                    $this->manager->saveFeedback($member, $query['shareId'], $shareDate, $query['isSatisfied'], $recipient);
                }
            }

            // Get invoice id, if exists in request query parameter (after renewal redirection back)
            $invoiceId = isset($request->query->all()['invoiceId']) ? isset($request->query->all()['invoiceId']) : null;

            return $this->render('owner/membership/member/profile.html.twig', [
                'form' => $form->createView(),
                'renewForm' => $renewForm->createView(),
                'invoice' => $invoiceId ? $this->manager->getInvoice($request->query->all()['invoiceId']) : null,
                'status' =>  $this->manager->getMemberManager()->getMemberStatus($member)
            ]);
        }

        return $this->redirectToRoute('membership');
    }

    /**
     * @param Request $request
     * @return JsonResponse|Response
     */
    public function saveRenewalView(Request $request)
    {
        try {
            $buildingId = $request->query->get('buildingId');
            $ownerId = $request->query->get('ownerId');
            $step = $request->query->get('step');
            $this->manager->saveRenewalView($buildingId, $ownerId, $step);

            $response = new JsonResponse(['result' => 'Purchase (' . $step . ') view was saved!'], 200);
        } catch (\Exception $exception) {
            $response = new JsonResponse(['error' => $exception->getMessage()], 500);
        }

        $response->setCallback($request->get('callback'));

        return $response;
    }

    /**
     * @param Request $request
     * @return JsonResponse|Response
     */
    public function sendRenewalError(Request $request)
    {
        try {
            $error = $request->query->get('error');
            $browser = $request->query->get('browser');
            $content = $request->query->get('content');

            $subject = 'Market widget Javascript Error Notify - ' . $browser . '! ';

            $this->mailer->sendExceptionNotify($subject, $error, $content);
            $response = new JsonResponse(['result' => 'Javascript exception was sent to the admin!'], 200);
        } catch (\Exception $exception) {
            $response = new JsonResponse(['error' => $exception->getMessage()], 500);
        }

        $response->setCallback($request->get('callback'));

        return $response;
    }

    /**
     * @param Request $request
     * @param SerializerInterface $serializer
     * @param $token
     * @return JsonResponse
     */
    public function saveProfile(Request $request, SerializerInterface $serializer, $token)
    {
        $member = $this->manager->findOneByToken($token);

        $status = 'invalid';

        if ($member) {
            $form = $this->createForm(OwnerType::class, $member, ['isMembership' => true]);
            $form->handleRequest($request);

            if ($form->isSubmitted() && $form->isValid()) {
                try {
                    $this->manager->getMemberManager()->update($member);
                    $status = "saved";
                } catch (\Exception $e) {
                    $status = $e->getMessage();
                }
            } else {
                return new JsonResponse($serializer->serialize(['error' => $form], 'json'), 500);
            }
        }

        return new JsonResponse(['status' => $status]);
    }

    /**
     * @param Owner $member
     * @return JsonResponse
     */
    public function delete(Owner $member)
    {
        $em = $this->getDoctrine()->getManager();

        $em->remove($member);
        $em->flush();

        return new JsonResponse(['redirect' => $this->generateUrl('membership'), 'status' => 'success'], 202);
    }

    /**
     * @param Request $request
     * @param $token
     * @return \Symfony\Component\HttpFoundation\RedirectResponse|Response
     */
    public function vendorProfile(Request $request, $token)
    {
        $contact = $this->manager->findVendorContactByToken($token);

        if ($contact) {
            $building = $contact->getVendor()->getBuilding();

            // Create Profile tab form
            $form = $this->createForm(ContactType::class, $contact);
            $form->handleRequest($request);

            if ($form->isSubmitted() && $form->isValid()) {
                $this->manager->flush();

                return $this->redirect($this->generateUrl('vendor_profile', ['token' => $token]) . '#profile');
            }

            $return = [
                'form' => $form->createView()
            ];

            // If vendor is activated add to response orders forms for Orders tab
            if ($contact->getVendor()->isActive()) {
                $order = new VendorOrder();

                $orderForm = $this->createForm(VendorOrderType::class, $order, [
                    'vendors' => [$contact->getVendor()]
                ]);

                $orderForm->handleRequest($request);

                if ($form->isSubmitted() && $orderForm->isValid()) {
                    $order->setBuilding($building);
                    $this->manager->createVendorOrder($order);

                    return $this->redirect($this->generateUrl('vendor_profile', ['token' => $token]) . '#order');
                }

                $productsForms = [];

                $orders = $this->manager->getVendorOrders($contact->getVendor());

                $return += [
                    'orderForm' => $orderForm->createView(),
                    'orders' => $orders,
                    'productsForms' => $productsForms
                ];
            }

            return $this->render('owner/membership/vendor/profile.html.twig', $return);
        }

        return $this->redirectToRoute('membership');
    }


    /**
     * @param Request $request
     * @param UrlGeneratorInterface $urlGenerator
     * @param Owner $member
     * @return JsonResponse
     */
    public function sendTestimonialMail(Request $request, UrlGeneratorInterface $urlGenerator, Owner $member)
    {
        try {
            $recipient = $this->manager->createTestimonialRecipient(
                $member,
                $request->request->get('email'),
                $request->request->get('firstname'),
                $request->request->get('lastname'),
                $request->request->get('message')
            );

            $signUpLink = $urlGenerator->generate('referred_owner_create', [
                'recipientId' => urlencode(base64_encode($recipient->getId()))
            ], UrlGeneratorInterface::ABSOLUTE_URL);

            if ($signUpLink) {
                $this->mailer->sendMail(
                    $this->getParameter('software_name'),
                    $recipient->getEmail(),
                    'owner/emails/testimonial_email.html.twig',
                    'Invitation to join ' . $member->getBuilding()->getName(),
                    [
                        'buildingName' => $member->getBuilding()->getName(),
                        'firstname' => $recipient->getFirstname(),
                        'lastname' => $recipient->getLastname(),
                        'message' => $recipient->getMessage(),
                        'signUpLink' => $signUpLink
                    ]
                );
            } else {
                throw new \Exception('Sign up link cant be created.');
            }
        } catch (\Exception $exception) {
            return new JsonResponse(['error' => $exception->getMessage()], 500);
        }

        return new JsonResponse(['status' => 'Testimonial email successfully saved and sent.'], 200);
    }

    /**
     * @param $recipientId
     * @return \Symfony\Component\HttpFoundation\RedirectResponse|Response
     */
    public function referredOwnerCreate($recipientId)
    {
        $recipient = $this->manager->getTestimonialRecipientById(base64_decode(urldecode($recipientId)));

        if (!$recipient) {
            return new Response('Affiliate email wasn`t found.');
        }

        $existsOwner = $this->manager->findOneByEmail($recipient->getEmail(), $recipient->getAffiliate()->getBuilding());

        if (!$existsOwner) {
            $owner = $this->manager->createOwnerFromTestimonial($recipient);

            return $this->redirectToRoute('membership_profile', ['token' => $owner->getToken()]);
        } else {
            return $this->redirectToRoute('membership_profile', ['token' => $existsOwner->getToken()]);
        }
    }
}