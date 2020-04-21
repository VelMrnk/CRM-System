<?php

namespace App\Manager;

use App\Entity\Client\Affiliate;
use App\Entity\Client\Client;
use App\Entity\Customer\Email\AutoEmail;
use App\Entity\Customer\Location;
use App\Entity\Client\ModuleAccess;
use App\Entity\Client\Referral;
use App\Entity\Client\Team;
use App\Entity\Translation\TranslationLocale;
use App\Entity\User\User;
use App\Security\AccessUpdater;
use App\Service\CountryList;
use App\Service\MailService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Form\FormError;
use Symfony\Component\Security\Core\Encoder\UserPasswordEncoderInterface;
use Symfony\Component\Security\Csrf\TokenGenerator\TokenGeneratorInterface;
use Symfony\Contracts\Translation\TranslatorInterface;
use Twig\Environment;

class RegistrationManager
{
    private $em;

    private $passwordEncoder;

    private $token;

    private $twig;

    private $translator;

    private $mailService;

    private $countryList;


    public function __construct(
        EntityManagerInterface $em,
        UserPasswordEncoderInterface $passwordEncoder,
        TokenGeneratorInterface $token,
        Environment $twig,
        TranslatorInterface $translator,
        MailService $mailService,
        CountryList $countryList
    ) {
        $this->em = $em;
        $this->passwordEncoder = $passwordEncoder;
        $this->token = $token;
        $this->twig = $twig;
        $this->translator = $translator;
        $this->mailService = $mailService;
        $this->countryList = $countryList;
    }

    /**
     * @param User $user
     * @param string $clientName
     * @return User|FormError
     * @throws \Doctrine\DBAL\ConnectionException
     */
    public function register(User &$user, string $clientName)
    {
        $this->em->getConnection()->beginTransaction();

        try {
            $user->setRoles(['ROLE_OWNER']);
            $user->setPassword($this->passwordEncoder->encodePassword($user, $user->getPlainPassword()));
            $user->setConfirmationToken($this->token->generateToken());

            // Create new client and team
            $client = $this->createClient($clientName, $user->getEmail());
            $team = $this->createTeam($client, $user);

            // Create first location for pickups of client products (Home Delivery)
            $homeDeliveryLabel = $this->translator->trans('membership.renew.location.home_delivery', [], 'labels');
            $homeDeliveryLocation = $this->createLocation($homeDeliveryLabel, 'Delivery');
            $client->addLocation($homeDeliveryLocation);

            // Save client as new affiliate
            $affiliate = new Affiliate();
            $affiliate->setReferralCode(substr($this->token->generateToken(),0,20));
            $client->setAffiliate($affiliate);

            $this->createAccess($client);
            $this->createAutomatedEmails($client, $user->getLocale()->getCode());

            $this->em->persist($user);
            $this->em->persist($client);
            $this->em->persist($team);
            $this->em->flush();

            $this->mailService->sendEmailConfirmation($user);

            $this->em->getConnection()->commit();

            return $user;
        } catch (\Throwable $e) {
            $this->em->getConnection()->rollBack();
            $this->em->clear();

            return new FormError(
                'Error while trying to save user: ' . $e->getMessage() . ' on line - ' . $e->getLine() .  '.In file ' . $e->getFile()
            );
        }
    }

    /**
     * @param Client $client
     * @param string $refCode
     */
    public function createReferral(Client $client, string $refCode)
    {
        $affiliate = $this->em->getRepository(Affiliate::class)->findOneBy([
            'referralCode' => $refCode
        ]);

        if ($affiliate) {
            $referral = new Referral();
            $referral->setClient($client);
            $referral->setAffiliate($affiliate);

            $this->em->persist($referral);
            $this->em->flush();
        }
    }

    /**
     * @param Client $client
     * @param User $user
     * @param string $roles
     * @throws \Doctrine\DBAL\ConnectionException
     */
    public function addUserToClientTeam(Client $client, User $user, string $roles)
    {
        $this->em->getConnection()->beginTransaction();

        try {
            $user->setRoles(is_array($roles) ? $roles : [$roles]);
            $user->setPassword($this->passwordEncoder->encodePassword($user, $user->getPlainPassword()));
            $team = new Team($client, $user);

            $this->em->persist($team);
            $this->em->flush();
            $this->em->getConnection()->commit();
            $this->em->clear();
        } catch (\Exception $e) {
            $this->em->getConnection()->rollback();
            $this->em->clear();

            throw $e;
        }
    }

    /**
     * @param string $name
     * @param string $email
     * @return Client
     */
    private function createClient(string $name, string $email) : Client
    {
        $client = new Client();
        $client->setName($name);
        $client->setEmail($email);

        return $client;
    }

    /**
     * @param string $name
     * @param string $typeName
     * @return Location
     */
    private function createLocation(string $name, string $typeName)
    {
        // Add basic delivery location
        $location = new Location();
        $location->setName(mb_strtoupper($name));
        $location->setTypeByName($typeName);
        $location->addWorkDays();

        return $location;
    }

    /**
     * @param Client $client
     * @param User $user
     * @return Team
     */
    private function createTeam(Client &$client, User &$user)
    {
        $team = new Team($client, $user);
        $user->setTeam($team);
        $client->addTeam($team);

        return $team;
    }

    /**
     * @param Client $client
     * @throws \Exception
     */
    private function createAccess(Client $client)
    {
        // Set access to expired date after sign-up
        $today = new \DateTime();
        $trialExtendsAt = new \DateTime();
        $trialExtendsAt->modify('+' . AccessUpdater::TRIAL_DAYS . ' days');

        foreach (ModuleAccess::MODULES as $id => $name) {
            $access = new ModuleAccess();
            $access->setClient($client);
            $access->setModule($id);
            $access->setUpdatedAt($today);
            $access->setExpiredAt($today);
            $access->setStatusByName('ACTIVE');
        }
    }

    /**
     * @param Client $client
     * @param string $locale
     * @throws \Twig\Error\LoaderError
     * @throws \Twig\Error\RuntimeError
     * @throws \Twig\Error\SyntaxError
     */
    public function createAutomatedEmails(Client $client, string $locale)
    {
        // Run through all automated email types defined in manager
        foreach (AutoEmail::EMAIL_TYPES as $id => $typeName) {
            $subject = $this->translator->trans(('emails.' . $typeName . '.subject'), [], 'labels', $locale);
            $template = $this->twig->render('customer/emails/default/' . $typeName . '.html.twig');

            $email = new AutoEmail();
            $email->setType($id);
            $email->setSubject($subject);
            $email->setText($template);
            $client->addAutoMail($email);

            $this->em->flush();
        }
    }

    /**
     * @param $email
     * @return User|object|null
     */
    public function findUserByEmail($email)
    {
        return $this->em->getRepository(User::class)->findOneBy(['email' => $email]);
    }

    /**
     * @param $username
     * @return User|object|null
     */
    public function findUserByUsername($username)
    {
        return $this->em->getRepository(User::class)->findOneBy(['username' => $username]);
    }

    /**
     * @param $token
     * @return User|object|null
     */
    public function findUserByConfirmationToken($token)
    {
        return $this->em->getRepository(User::class)->findOneBy(['confirmationToken' => $token]);
    }

    public function updateUser(User $user)
    {
        $this->em->persist($user);
        $this->em->flush();
    }

    public function save()
    {
        $this->em->flush();
    }

    /**
     * @return array
     */
    public function getLocales()
    {
        $dbLocales = $this->em->getRepository(TranslationLocale::class)->getAllLocales();
        $locales = [];

        foreach ($dbLocales as $locale) {
            $locales[$this->countryList->getLanguageByLocale($locale)] = $locale;
        }

        return $locales;
    }
}