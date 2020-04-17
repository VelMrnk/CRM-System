<?php

namespace App\Command;

use App\Manager\EmailManager;
use App\Manager\MemberEmailManager;
use App\Service\MailService;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class SendComposedEmailCommand extends Command
{
    protected static $defaultName = 'app:send-composed-email';

    private $manager;

    private $memberEmailManager;

    private $mailer;

    public function __construct(EmailManager $manager, MemberEmailManager $memberEmailManager, MailService $mailService)
    {
        parent::__construct();

        $this->manager = $manager;
        $this->memberEmailManager = $memberEmailManager;
        $this->mailer = $mailService;
    }

    protected function configure()
    {
        $this
            ->setDescription('Send composed emails to a recipients')
            ->addArgument('id', InputArgument::REQUIRED, 'id of the Email')
            ->addArgument('recipientType', InputArgument::REQUIRED, 'client/customer');
    }

    /**
     * @param InputInterface $input
     * @param OutputInterface $output
     * @return int|void
     */
    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $recipientType = $input->getArgument('recipientType');
        $output->writeln('Sending of emails to ' . $recipientType . 's:');

        $manager = $recipientType == 'customer' ? $this->memberEmailManager : $this->manager;

        $email = $manager->getEmail($input->getArgument('id'));
        $email->setInProcess(true);

        foreach ($email->getRecipients() as $recipient) {
            if (!$recipient->isDelivered() && $recipient->getEmailAddress()) {
                $message = $manager->setMacrosFields($recipient, $email->getText());
                $this->mailer->sendComposedMail($recipient, $message);

                $output->writeln('Email was sent to ' . $recipient->getEmailAddress() . '.');
            }
        }

        $manager->saveSentEmail($email);

        return 0;
    }
}