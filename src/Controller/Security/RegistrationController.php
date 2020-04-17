<?php

namespace App\Controller\Security;

use App\Entity\User\User;
use App\Event\RegistrationSuccessEvent;
use App\Form\Security\RegistrationType;
use App\Manager\RegistrationManager;
use App\Service\AuthorizedRedirect;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\EventDispatcher\EventDispatcherInterface;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\Form\FormError;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Exception\AccessDeniedHttpException;
use Symfony\Component\Routing\RouterInterface;

/**
 * Class RegistrationController
 * @package App\Controller
 */
class RegistrationController extends AbstractController
{
    private $manager;

    private $dispatcher;

    /**
     * RegistrationController constructor.
     *
     * @param RegistrationManager $manager
     * @param EventDispatcherInterface $dispatcher
     */
    public function __construct(RegistrationManager $manager, EventDispatcherInterface $dispatcher)
    {
        $this->manager = $manager;
        $this->dispatcher = $dispatcher;
    }

    /**
     * @param Request $request
     * @param AuthorizedRedirect $redirect
     * @return mixed|RedirectResponse|Response
     * @throws \Doctrine\DBAL\ConnectionException
     */
    public function register(Request $request, AuthorizedRedirect $redirect)
    {
        if ($redirectPath = $redirect->getAuthorizedRedirectPath($this->getUser())) {
            return new RedirectResponse($redirectPath);
        }

        $user = new User();
        $form = $this->createForm(RegistrationType::class, $user, [
            'validation_groups' => ['register_validation', 'Default']
        ]);
        $form->handleRequest($request);

        // Update locale
        if ($user->getLocale()) {
            $request->getSession()->set('_locale', $user->getLocale());
            $request->setLocale($user->getLocale());
        }

        if ($form->isSubmitted() && $form->isValid()) {
            $client = $request->request->get('registration')['client']['name'];
            $refCode = $request->getSession()->get('ref');

            $result = $this->manager->signUpUser($user, $client, $refCode);

            if ($result instanceof FormError) {
                $form->addError($result);
            } else {
                $event = new RegistrationSuccessEvent($user);
                $this->dispatcher->dispatch($event);

                return $event->getResponse();
            }
        }

        return $this->render('auth/registration/register.html.twig', [
            'form' => $form->createView()
        ]);
    }

    /**
     * @param Request $request
     * @param RouterInterface $router
     * @return RedirectResponse|Response
     */
    public function checkEmail(Request $request, RouterInterface $router)
    {
        $email = $request->getSession()->get('app_registration/email');

        if (empty($email)) {
            return new RedirectResponse($this->generateUrl('app_registration'));
        }

        $request->getSession()->remove('app_registration/email');
        $user = $this->manager->findUserByEmail($email);

        if (null === $user) {
            return new RedirectResponse($router->generate('app_login'));
        }

        return $this->render('auth/registration/check_email.html.twig', [
            'user' => $user,
        ]);
    }

    /**
     * @param $token
     * @return RedirectResponse
     */
    public function confirm($token)
    {
        $user = $this->manager->findUserByConfirmationToken($token);

        if (null === $user) {
            return $this->redirectToRoute('app_login');
        }

        $user->setConfirmationToken(null);
        $user->setEnabled(true);
        $this->manager->updateUser($user);

        return new RedirectResponse($this->generateUrl('app_registration_confirmed', [
            'username' => $user->getUsername()
        ]));
    }

    /**
     * @param $username
     * @return Response
     */
    public function confirmed($username)
    {
        $user = $this->manager->findUserByUsername($username);

        if (!is_object($user) || !$user instanceof User) {
            throw new AccessDeniedHttpException('This user does not have access to this section.');
        }

        return $this->render('auth/registration/confirmed.html.twig', [
            'user' => $user
        ]);
    }
}