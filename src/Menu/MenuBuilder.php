<?php

namespace App\Menu;

use App\Entity\Building\Building;
use App\Entity\User\User;
use App\Service\ModuleChecker;
use Knp\Menu\FactoryInterface;
use Symfony\Component\HttpFoundation\RequestStack;
use Symfony\Component\Security\Core\Security;
use Symfony\Contracts\Translation\TranslatorInterface;

class MenuBuilder
{
    private $factory;

    private $trans;

    private $security;

    private $request;

    private $moduleChecker;

    /**
     * MenuBuilder constructor.
     * @param FactoryInterface $factory
     * @param TranslatorInterface $translator
     * @param Security $security
     * @param RequestStack $request
     * @param ModuleChecker $moduleChecker
     */
    public function __construct(
        FactoryInterface $factory,
        TranslatorInterface $translator,
        Security $security,
        RequestStack $request,
        ModuleChecker $moduleChecker
    ) {
        $this->factory = $factory;
        $this->trans = $translator;
        $this->security = $security;
        $this->request = $request->getCurrentRequest();
        $this->moduleChecker = $moduleChecker;
    }

    /**
     * @param array $options
     * @return \Knp\Menu\ItemInterface
     */
    public function mainMenu(array $options)
    {
        $domain = 'labels';
        $menu = $this->factory->createItem('root');
        $building = $this->security->getUser()->getBuilding();

        // Master menu
        if ($this->security->isGranted('ROLE_ADMIN')) {
            $this->addMasterMenu($menu);
            $this->addMasterEmailsMenu($menu);
        }

        // Logout for for impersonated user
        if ($this->security->isGranted('ROLE_PREVIOUS_ADMIN')) {
            $menu->addChild('Back to Master', [
                'route' => 'master_dashboard',
                'routeParameters' => [
                    '_switch_user' => '_exit'
                ]
            ])->setAttribute('icon', 'icon-exit3');
        }

        // User menu
        if ($this->security->isGranted(User::ROLE_OWNER) || $this->security->isGranted(User::ROLE_EMPLOYEE)) {
            $this->addOwnerAccountMenu($menu, $domain);

            // Module Owners Header
            $ownersHeader = $this->trans->trans('navigation.module_owners', [], $domain);
            $menu->addChild($ownersHeader)->setAttribute('icon', 'icon-menu')->setAttribute('class', 'navigation-header');

            // Module Owners
            $this->addManageOwnersMenu($menu, $domain, $building);
            $this->addEmailsMenu($menu, $domain);
        }

        return $menu;
    }

    /**
     * @return \Knp\Menu\ItemInterface
     */
    public function getAllMenusItems()
    {
        $domain = 'labels';
        $menu = $this->factory->createItem('root');

        $this->addOwnerAccountMenu($menu, $domain);
        $ownersHeader = $this->trans->trans('navigation.module_owners', [], $domain);
        $menu->addChild($ownersHeader)->setAttribute('icon', 'icon-menu')->setAttribute('class', 'navigation-header');
        $this->addManageOwnersMenu($menu, $domain);
        $this->addEmailsMenu($menu, $domain);

        return $menu;
    }

    /**
     * @param $menu
     */
    private function addMasterMenu(&$menu)
    {
        $master = 'MASTER';
        $menu->addChild($master)->setAttribute('icon', 'icon-grid6')->setAttribute('class', 'has-ul');;
        $menu[$master]->addChild('Dashboard', ['route' => 'master_dashboard'])->setAttribute('icon', 'icon-home');
        $menu[$master]->addChild('Affiliates', ['route' => 'master_affiliates'])->setAttribute('icon', 'icon-tree7');
        $menu[$master]->addChild('Buildings', ['route' => 'master_buildings'])->setAttribute('icon', 'icon-users');
        $menu[$master]->addChild('Posts', ['route' => 'master_blog'])->setAttribute('icon', 'icon-newspaper');
        $menu[$master]->addChild('Statistics', ['route' => 'master_statistics'])->setAttribute('icon', 'icon-stats-bars2');
        $menu[$master]->addChild('Media Manager', ['route' => 'master_image_manager'])->setAttribute('icon', 'icon-image2');
    }

    /**
     * @param $menu
     */
    private function addMasterEmailsMenu(&$menu)
    {
        $emails = 'EMAIL';
        $menu->addChild($emails)->setAttribute('icon', 'icon-envelope')->setAttribute('class', 'has-ul');;
        $menu[$emails]->addChild('Auto', ['route' => 'master.email.auto'])->setAttribute('icon', 'icon-history');
        $menu[$emails]->addChild('Drafts', ['route' => 'master.email.drafts'])->setAttribute('icon', 'icon-notebook');
        $menu[$emails]->addChild('Compose', ['route' => 'master.email.compose'])->setAttribute('icon', 'icon-compose');
        $menu[$emails]->addChild('Logs', ['route' => 'master.email.log'])->setAttribute('icon', 'icon-book');
    }

    /**
     * @param $menu
     * @param $domain
     */
    private function addOwnerAccountMenu(&$menu, $domain)
    {
        $account = $this->trans->trans('navigation.account.account', [], $domain);
        $menu->addChild($account)->setAttribute('icon', 'icon-cog3')->setAttribute('class', 'has-ul');;
        $menu[$account]->addChild($this->trans->trans('navigation.account.profile', [], $domain), ['route' => 'profile_edit'])->setAttribute('icon', 'icon-user');

        $menu[$account]->addChild($this->trans->trans('navigation.account.users', [], $domain), ['route' => 'user_index'])->setAttribute('icon', 'icon-user-plus');
    }

    /**
     * @param $menu
     * @param $domain
     * @param Building|null $building
     */
    private function addManageOwnersMenu(&$menu, $domain, ?Building $building = null)
    {
        $owners = $this->trans->trans('navigation.owners.manage_owners', [], $domain);
        $menu->addChild($owners)->setAttribute('icon', 'icon-people')->setAttribute('class', 'has-ul');;
        $menu[$owners]->addChild($this->trans->trans('navigation.owners.add', [], $domain), ['route' => 'member_add'])->setAttribute('icon', 'icon-user-plus');

        $filterBy = $this->request->cookies->get('ownersFilterBy');
        if ($filterBy === null || $filterBy === 'undefined') $filterBy = 'all';

        $menu[$owners]->addChild($this->trans->trans('navigation.owners.search', [], $domain), [
            'route' => 'owner_list',
            'routeParameters' => [
                'searchBy' => $filterBy
            ]
        ])->setAttribute('icon', 'icon-search4');

        $menu[$owners]->addChild($this->trans->trans('navigation.owners.upload', [], $domain), ['route' => 'members_parse'])->setAttribute('icon', 'icon-file-excel');
    }

    /**
     * @param $menu
     * @param $domain
     */
    private function addEmailsMenu(&$menu, $domain)
    {
        $emails = $this->trans->trans('navigation.emails.emails', [], $domain);
        $menu->addChild($emails)->setAttribute('icon', 'icon-envelop3')->setAttribute('class', 'has-ul');;
        $menu[$emails]->addChild($this->trans->trans('navigation.emails.auto', [], $domain), ['route' => 'member.email.auto'])->setAttribute('icon', 'icon-history');
        $menu[$emails]->addChild($this->trans->trans('navigation.emails.drafts', [], $domain), ['route' => 'member.email.draft'])->setAttribute('icon', 'icon-notebook');
        $menu[$emails]->addChild($this->trans->trans('navigation.emails.compose', [], $domain), ['route' => 'member.email.compose'])->setAttribute('icon', 'icon-compose');
        $menu[$emails]->addChild($this->trans->trans('navigation.emails.logs', [], $domain), ['route' => 'member.email.log'])->setAttribute('icon', 'icon-book');
    }
}