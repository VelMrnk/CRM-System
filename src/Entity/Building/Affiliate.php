<?php

namespace App\Entity\Building;

use Symfony\Component\Validator\Constraints as Assert;
use Symfony\Bridge\Doctrine\Validator\Constraints\UniqueEntity;

use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Table(name="building__affiliate", uniqueConstraints={@ORM\UniqueConstraint(name="affiliate_unique", columns={"name", "email"})})
 * @ORM\Entity(repositoryClass="App\Repository\AffiliateRepository")
 * @UniqueEntity(fields={"email"}, errorPath="email", message="validation.form.unique")
 */

class Affiliate 
{
    public function __construct()
    {
        $this->createdAt = new \DateTime();
    }

    /**
     * @var int
     *
     * @ORM\Column(name="id", type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**
     * @ORM\OneToOne(targetEntity="App\Entity\Building\Building", inversedBy="affiliate")
     * @ORM\JoinColumn(name="building_id", referencedColumnName="id", nullable=true)
     */
    private $building;

    /**
     * @var string
     * @ORM\Column(name="name", type="string", length=255, nullable=true)
     * @Assert\NotBlank(message="validation.form.required", groups={"register_validation", "profile_validation"})
     */
    private $name;

    /**
     * @ORM\Column(name="email", type="string", length=25, nullable=true)
     * @Assert\Email(message = "validation.form.not_valid_email")
     * @Assert\NotBlank(message="validation.form.required")
     */
    protected $email;

    /**
     * @var string
     * @ORM\Column(name="referral_code", type="string", length=20, nullable=false, unique=true)
     */
    private $referralCode;

    /**
     * @ORM\OneToMany(targetEntity="App\Entity\Building\Referral", mappedBy="affiliate")
     */
    private $referrals;

    /**
     * @var \DateTime
     *
     * @ORM\Column(name="created_at", type="date")
     */
    private $createdAt;


    /**
     * Get id
     *
     * @return int
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * @param $building
     * @return $this
     */
    public function setBuilding($building)
    {
        $this->building = $building;

        return $this;
    }

    /**
     * @return string
     */
    public function getBuilding()
    {
        return $this->building;
    }

    /**
     * @param $name
     * @return $this
     */
    public function setName($name)
    {
        $this->name = $name;

        return $this;
    }

    /**
     * @return mixed
     */
    public function getEmail()
    {
        return $this->email;
    }

    /**
     * @param $email
     * @return $this
     */
    public function setEmail($email)
    {
        $this->email = strtolower($email);

        return $this;
    }

    /**
     * Get name
     *
     * @return string
     */
    public function getName()
    {
        return $this->name;
    }

    /**
     * @param $referralCode
     * @return $this
     */
    public function setReferralCode($referralCode)
    {
        $this->referralCode = $referralCode;

        return $this;
    }

    /**
     * Get referralCode
     *
     * @return string
     */
    public function getReferralCode()
    {
        return $this->referralCode;
    }

    public function getReferralLink()
    {
        return 'http://' . $_SERVER['HTTP_HOST'] . '/register/?ref=' . $this->getReferralCode();
    }

    /**
     * @return mixed
     */
    public function getReferrals()
    {
        return $this->referrals;
    }
    

    /**
     * @param $createdAt
     * @return $this
     */
    public function setCreatedAt($createdAt)
    {
        $this->createdAt = $createdAt;

        return $this;
    }

    /**
     * Get createdAt
     *
     * @return \DateTime
     */
    public function getCreatedAt()
    {
        return $this->createdAt;
    }
}