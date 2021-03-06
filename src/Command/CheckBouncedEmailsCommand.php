<?php

namespace App\Command;

use App\Entity\Master\Email\Recipient;
use App\Entity\Owner\Email\EmailRecipient;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class CheckBouncedEmailsCommand extends Command
{
    protected static $defaultName = 'app:check-bounced-emails';

    private $em;

    private $server;

    private $user;

    private $pass;

    public function __construct(EntityManagerInterface $em, $server, $user, $pass)
    {
        parent::__construct();

        $this->em = $em;
        $this->server = $server;
        $this->user = $user;
        $this->pass = $pass;
    }

    protected function configure()
    {
        $this->setDescription('Check sender inbox for bounced emails.');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        try {
            // Connect to sender email account by IMAP
            $path = '{' . $this->server . ':' . 143 . '/novalidate-cert}INBOX';
            $inbox = imap_open($path, $this->user, $this->pass) or die('Cannot connect to ' . $this->server . ': ' . imap_last_error());

            // Get all emails for last 12 minutes
            $search = 'SINCE "' . date("j F Y H:i:s", strtotime("-12 minutes")) . '"';
            $emails = imap_search($inbox, $search);

            $recipientsIds = [];

            $output->writeln([
                '============',
                'Start reading of emails from: ' . $this->server . ' (' . $this->user . ')',
                '============',
                'Found emails in last 12 minutes: ' . count($emails)
            ]);

            if ($emails) {
                rsort($emails);

                foreach ($emails as $i) {
                    $body = imap_body($inbox, $i);
                    $headers = $this->parse_rfc822_headers($body);

                    $recipientIdHeader = 'X-Mail-Recipient-ID';
                    $recipientTypeHeader = 'X-Mail-Recipient-Type';
                    if (isset($headers[$recipientIdHeader]) && isset($headers[$recipientTypeHeader])) {
                        $recipientsIds[$headers[$recipientIdHeader]][] = $headers[$recipientTypeHeader];
                    }
                }

                $buildingNum = isset($recipientsIds['building']) ? count($recipientsIds['building']) : 0;
                $ownerNum = isset($recipientsIds['owner']) ? count($recipientsIds['owner']) : 0;

                $output->writeln([
                    'Number of bounced emails: ' . ($buildingNum + $ownerNum),
                    'Building emails: ' . $buildingNum,
                    'Owner emails: ' . $ownerNum,
                ]);

                $updatedNum = 0;

                if ($recipientsIds) {
                    if (isset($recipientsIds['owner'])) {
                        $recipients = $this->em->getRepository(EmailRecipient::class)->getRecipientsByIds($recipientsIds['owner']);

                        if ($recipients) {
                            foreach ($recipients as $recipient) {
                                $recipient->setIsDelivered(false);
                                $recipient->setIsBounced(true);

                                $output->writeln('Set owner email as bounced. ID: ' . $recipient->getId());
                                $updatedNum++;
                            }

                            $this->em->flush();
                        }
                    }

                    if (isset($recipientsIds['building'])) {
                        $recipients = $this->em->getRepository(Recipient::class)->getRecipientsByIds($recipientsIds['building']);

                        if ($recipients) {
                            foreach ($recipients as $recipient) {
                                $recipient->setIsDelivered(false);
                                $recipient->setIsBounced(true);

                                $output->writeln('Set building email as bounced. ID: ' . $recipient->getId());
                                $updatedNum++;
                            }

                            $this->em->flush();
                        }
                    }

                }

                $output->writeln('Number of updated emails: ' . $updatedNum);
            }
        } catch (\Exception $exception) {

        }

        return 0;
    }

    /**
     * @param string $header_string
     * @return array
     */
    function parse_rfc822_headers(string $header_string): array
    {
        preg_match_all('/([^:\s]+): (.*?(?:\r\n\s(?:.+?))*)\r\n/m', $header_string, $matches);
        $headers = $this->array_combine_groupkeys($matches[1], $matches[2]);

        return $headers;
    }

    /**
     * @param array $keys
     * @param array $values
     * @return array
     */
    function array_combine_groupkeys(array $keys, array $values): array
    {
        $result = [];

        foreach ($keys as $i => $k) {
            $result[$k][] = $values[$i];
        }

        array_walk($result,
            function (&$v) {
                $v = (count($v) === 1) ? array_pop($v): $v;
            }
        );

        return $result;
    }
}