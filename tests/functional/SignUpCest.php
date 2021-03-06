<?php

namespace App\Tests;

use App\DataFixtures\UserFixtures;

class SignUpCest
{
    /**
     * @param FunctionalTester $I
     */
    public function testGoToSignUpPage(FunctionalTester $I)
    {
        $I->wantToTest('Sign up page');
        $I->amOnRoute('app_registration');
        $I->see('Create account');
    }

    /**
     * @before testGoToSignUpPage
     * @param FunctionalTester $I
     */
    public function testSignUpWithEmptyFields(FunctionalTester $I)
    {
        $I->wantToTest('Sign up with empty fields');

        $formFields = [
            'registration_username' => '',
            'registration_email' => '',
            'registration_building_name' => '',
            'registration_plainPassword_first' => '',
            'registration_plainPassword_second' => ''
        ];

        foreach ($formFields as $fieldId => $value) {
            if ($value !== null) {
                $I->fillField("#$fieldId", $value);
            }
        }

        $I->click('#_submit');
        $I->see('Create account');

        $I->iSeeValidationErrorLabels($formFields);
    }

    /**
     * @before testGoToSignUpPage
     * @param FunctionalTester $I
     */
    public function testSwitchOfLanguage(FunctionalTester $I)
    {
        $I->wantToTest('Work of language switcher.');
        $I->see('Create account');

        $switchToEnglish = $I->grabAttributeFrom('option[value=1]', 'data-switch-path');
        $I->amOnPage($switchToEnglish);
        $I->see('Create account');

        $switchToRussian = $I->grabAttributeFrom('option[value=2]', 'data-switch-path');
        $I->amOnPage($switchToRussian);
        $I->see('Создать аккаунт');
    }

    /**
     * @before testGoToSignUpPage
     * @param FunctionalTester $I
    */
    public function testSignUpWithUniqueError(FunctionalTester $I)
    {
        $I->wantToTest('Sign up with unique validation');

        $enabledUser = UserFixtures::ENABLED_USER;

        $formFields = [
            'registration_username' => $enabledUser['username'],
            'registration_email' => $enabledUser['email'],
            'registration_locale' => [1],
            'registration_building_name' => $enabledUser['building']['name'],
            'registration_plainPassword_first' => 'testuser',
            'registration_plainPassword_second' => 'testuser'
        ];

        $I->fillForm($formFields);
        $I->click('#_submit');
        $I->see('Create account');

        $I->iSeeLabelError('registration_username', 'This value must be unique.');
        $I->iSeeLabelError('registration_email', 'This value must be unique.');
        $I->iSeeLabelError('registration_building_name', 'This value must be unique.');
    }

    /**
     * @before testGoToSignUpPage
     * @param FunctionalTester $I
     */
    public function testSuccessfulSignUp(FunctionalTester $I)
    {
        $I->wantToTest('Successful Sign Up');

        $formFields = [
            'registration_username' => 'johngolt',
            'registration_locale' => [1],
            'registration_email' => 'johngolt@example.com',
            'registration_building_name' => 'John Golt',
            'registration_plainPassword_first' => 'johngolt',
            'registration_plainPassword_second' => 'johngolt'
        ];

        $I->fillForm($formFields);
        $I->click('#_submit');

        $I->canSeeInCurrentUrl('/register/check-email');
        $I->see('Your account has been created');
        $I->seeSoftwareName();
    }
}
