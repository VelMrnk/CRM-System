<?php

namespace App\Entity\Building;

use App\Entity\User\User;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;
use App\Entity\Owner\Email\AutoEmail;
use App\Entity\Owner\Owner;
use Symfony\Component\Validator\Constraints as Assert;
use Symfony\Bridge\Doctrine\Validator\Constraints\UniqueEntity;
use Doctrine\Common\Collections\ArrayCollection;

/**
 * @ORM\Table(name="building")
 * @ORM\Entity(repositoryClass="App\Repository\BuildingRepository")
 * @UniqueEntity(fields={"name"}, errorPath="name", message="validation.form.unique", groups={"register_validation", "profile_validation"})
 */
class Building
{
    /**
     * @var int
     *
     * @ORM\Column(name="id", type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;
    
    /**
     * @var string
     * @ORM\Column(name="name", type="string", length=255, unique=true, nullable=false)
     * @Assert\NotBlank(message="validation.form.required", groups={"register_validation", "profile_validation"})
     */
    private $name;

    /**
     * @ORM\Column(name="email", type="string", length=50, nullable=false)
     * @Assert\Email(message = "validation.form.not_valid_email")
     * @Assert\NotBlank(message="validation.form.required", groups={"profile_validation"})
     */
    private $email;

    /**
     * @var int
     *
     * @ORM\Column(name="currency", type="integer", length=2, nullable=true)
     */
    private $currency;

    /**
     * @var int
     *
     * @ORM\Column(name="timezone", type="string", length=30, nullable=true)
     */
    protected $timezone;

    /**
     * @ORM\Column(name="token", type="string", length=30)
     */
    private $token;

    /**
     * @var \DateTime
     *
     * @ORM\Column(name="created_at", type="date")
     */
    private $createdAt;

    /**
     * @ORM\OneToMany(targetEntity="App\Entity\Building\ModuleAccess", mappedBy="building", cascade={"all"})
     */
    private $accesses;

    /**
     * @ORM\OneToMany(targetEntity="App\Entity\Building\Subscription", mappedBy="building", cascade={"remove"})
     */
    private $subscriptions;

    /**
     * @ORM\OneToMany(targetEntity="App\Entity\Owner\Owner", mappedBy="building", cascade={"remove"})
     */
    private $owners;

    /**
     * @ORM\OneToOne(targetEntity="App\Entity\Building\Affiliate", mappedBy="building", cascade={"all"})
     */
    private $affiliate;

    /**
     * @ORM\OneToMany(targetEntity="App\Entity\Owner\Email\OwnerEmail", mappedBy="building", cascade={"remove"})
     */
    private $emails;

    /**
     * @ORM\OneToMany(targetEntity="App\Entity\Owner\Email\AutoEmail", mappedBy="building", cascade={"all"})
     */
    private $autoEmails;

    /**
     * @ORM\OneToMany(targetEntity="App\Entity\Building\Post", mappedBy="building", cascade={"persist", "remove"})
     */
    private $posts;

    /**
     * @ORM\OneToMany(targetEntity="App\Entity\Media\Image", mappedBy="building", cascade={"persist", "remove"})
     */
    private $images;

    /**
     * @ORM\OneToMany(targetEntity="App\Entity\Owner\Apartment", mappedBy="building", cascade={"remove"})
     */
    private $apartments;

    /**
     * @ORM\OneToMany(targetEntity="App\Entity\User\User", mappedBy="building", cascade={"remove"})
     */
    private $users;

    /**
     * @ORM\OneToOne(targetEntity="App\Entity\Building\Address", cascade={"all"})
     * @ORM\JoinColumn(name="address_id", referencedColumnName="id")
     */
    private $address;

    /**
     * Building constructor.
     * @throws \Exception
     */
    public function __construct()
    {
        $this->token = substr(base_convert(sha1(uniqid(mt_rand())), 16, 36), 0, 30);
        $this->createdAt = new \DateTime();

        $this->accesses =  new ArrayCollection();
        $this->posts = new ArrayCollection();
    }

    public function __toString()
    {
        return $this->name;
    }

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
     * @return $this
     */
    public function setId($id)
    {
        $this->id = $id;

        return $this;
    }

    /**
     * Set name
     *
     * @param string $name
     *
     * @return Building
     */
    public function setName($name)
    {
        $this->name = $name;

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
     * @return mixed
     */
    public function getEmail()
    {
        return $this->email;
    }


    /**
     * @param mixed $email
     */
    public function setEmail($email)
    {
        $this->email = $email;
    }

    /**
     * @param Affiliate $affiliate
     */
    public function setAffiliate(Affiliate $affiliate)
    {
        $this->affiliate = $affiliate;
    }

    /**
     * @return int
     */
    public function getCurrency()
    {
        return $this->currency;
    }

    /**
     * @param int $currency
     */
    public function setCurrency($currency)
    {
        $this->currency = $currency;
    }

    /**
     * @return int
     */
    public function getTimezone()
    {
        return $this->timezone;
    }

    /**
     * @param mixed $timezone
     */
    public function setTimezone($timezone)
    {
        $this->timezone = $timezone;
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
     * @param mixed $token
     */
    public function setToken($token)
    {
        $this->token = $token;
    }

    /**
     * @return string
     */
    public function getToken()
    {
        return $this->token;
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

    /**
     * @return mixed
     */
    public function getReferralLink()
    {
        return $this->getAffiliate()->getReferralLink();
    }

    /**
     * @return mixed
     */
    public function getMembershipLink()
    {
        return 'http://' . $_SERVER['HTTP_HOST'] . '/membership/member/sign-up/' . $this->getToken();
    }

    /**
     * @param Owner $owner
     * @return $this
     */
    public function addOwner(Owner $owner)
    {
        $this->owners[] = $owner;

        return $this;
    }

    /**
     * @param Owner $owner
     */
    public function removeOwner(Owner $owner)
    {
        $this->owners->removeElement($owner);
    }

    /**
     * Get owners
     *
     * @return Collection|Owner[] $owners
     */
    public function getOwners()
    {
        return $this->owners;
    }

    /**
     * Get accesses
     *
     * @return Collection|ModuleAccess[] $accesses
     */
    public function getAccesses()
    {
        return $this->accesses;
    }

    public function setAccesses(?array $accesses = [])
    {
        $this->accesses = $accesses;
    }

    public function getAffiliate()
    {
        return $this->affiliate;
    }

    /**
     * @return mixed
     */
    public function getAutoEmails()
    {
        return $this->autoEmails;
    }

    /**
     * @param mixed $autoEmails
     */
    public function setAutoEmails($autoEmails)
    {
        $this->autoEmails = $autoEmails;
    }

    /**
     * @param AutoEmail $autoEmail
     * @return $this
     */
    public function addAutoMail(AutoEmail $autoEmail)
    {
        $autoEmail->setBuilding($this);
        $this->autoEmails[] = $autoEmail;

        return $this;
    }

    /**
     * @return mixed
     */
    public function getPosts()
    {
        return $this->posts;
    }

    /**
     * @param mixed $posts
     */
    public function setPosts($posts)
    {
        $this->posts = $posts;
    }

    /**
     * @return mixed
     */
    public function getImages()
    {
        return $this->images;
    }

    /**
     * @return Address|null
     */
    public function getAddress(): ?Address
    {
        return $this->address;
    }

    /**
     * @param Address $address
     */
    public function setAddress(Address $address): void
    {
        $this->address = $address;
    }

    /**
     * @return Collection|User[] $users
     */
    public function getUsers()
    {
        return $this->users;
    }

    /**
     * @param mixed $users
     */
    public function setUsers($users): void
    {
        $this->users = $users;
    }
}
