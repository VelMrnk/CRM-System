<?php

namespace App\Manager;

use App\Entity\Client\Client;
use App\Entity\Customer\Address;
use App\Entity\Customer\Customer;
use Doctrine\ORM\EntityManagerInterface;

class ImportManager
{
    private $memberManager;

    private $em;

    public function __construct(MemberManager $memberManager, EntityManagerInterface $em)
    {
        $this->memberManager = $memberManager;
        $this->em = $em;
    }

    /**
     * @param Client $client
     * @param $customers
     * @param $status
     * @return int
     */
    public function importCustomers(Client $client, $customers, $status)
    {
        $fileEmails = [];

        // Get all emails from file
        foreach ($customers as $customer) {
            $fileEmails[] = trim(strtolower($customer['Email']));
        }

        // Find same emails in database for handle duplicate import by emails checking
        $databaseEmails = $this->memberManager->findEmailsMatch($client, $fileEmails);

        $counter = 0;

        foreach ($customers as $customer)
        {
            // If all needed fields for customer exists and duplicates of emails not found in database
            if ($this->array_keys_exists(['Email', 'First name', 'Last name'], $customer)
                && strlen($customer['Email']) > 4 && strlen($customer['First name']) > 1 && strlen($customer['Last name']) > 1
                && !in_array(trim(strtolower($customer['Email'])), $databaseEmails))
            {
                try {
                    // If customer with same email doesn't exists
                    $newCustomer = new Customer();
                    $newCustomer->setClient($client);
                    $newCustomer->setFirstname($customer['First name']);
                    $newCustomer->setLastname($customer['Last name']);
                    $newCustomer->setEmail($customer['Email']);
                    $newCustomer->setPhone($customer['Phone']);
                    $newCustomer->setNotes($customer['Additional information']);
                    $newCustomer->setIsLead($status);

                    // If all needed fields for address exists and not empty
                    if ($this->isLengthValid([$customer['Address'], $customer['Postal code'], $customer['Province/State'], $customer['City']], 2)) {
                        // Set customer address data
                        $address = new Address();
                        $address->setType(2);
                        $address->setCountry($client->getCountry());
                        $address->setStreet($customer['Address']);
                        $address->setPostalCode($customer['Postal code']);
                        $address->setRegion($customer['Province/State']);
                        $address->setCity($customer['City']);

                        // Add new address to user
                        $newCustomer->addAddress($address);
                    }

                    $this->saveCustomer($newCustomer);

                    // Save emails in array to prevent duplicates
                    $databaseEmails[] = trim(strtolower($customer['Email']));

                    $counter++;
                } catch (\Exception $e) {
                    die(var_dump($e->getMessage()));
                }
            }
        }

        // Save everything
        $this->em->flush();
        $this->em->clear();

        return $counter;
    }

    /**
     * array_key_exists for multiple keys
     *
     * @param array $keys
     * @param array $arr
     * @return bool
     */
    function array_keys_exists($keys = [], $arr = [])
    {
        return !array_diff_key(array_flip($keys), $arr);
    }

    /**
     * @param $values array
     * @param $length integer
     * @return bool
     */
    public function isLengthValid($values, $length)
    {
        $valid = true;

        if (!is_array($values)) $values = [$values];

        for ($i = 0; $i < count($values); $i++) {
            if (strlen($values[$i]) < $length) {
                $valid = false;

                break;
            }
        }

        return $valid;
    }

    /**
     * @param Customer $customer
     */
    public function saveCustomer(Customer $customer)
    {
        $customer->setToken($customer->getFirstname() . $customer->getLastname() . $customer->getEmail());

        // Add all email notifies to a customer, add pickups and update share statuses
        $this->memberManager->activateNotifications($customer);
        $this->em->persist($customer);
    }
}