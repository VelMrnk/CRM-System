<?php

namespace App\Form\User;

use App\Entity\Translation\TranslationLocale;
use App\Entity\User\User;
use App\Form\ClientType;
use App\Form\EventListener\ProfileSubscriber;
use App\Repository\Translation\TranslationLocaleRepository;
use App\Service\CountryList;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Validator\Constraints\Valid;

class UserFormType extends AbstractType
{
    private $subscriber;

    private $countryList;

    public function __construct(ProfileSubscriber $subscriber, CountryList $countryList)
    {
        $this->subscriber = $subscriber;
        $this->countryList = $countryList;
    }

    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('locale', EntityType::class , [
                'class' => TranslationLocale::class,
                'query_builder' => function (TranslationLocaleRepository $repository) {
                    return $repository->createQueryBuilder('t');
                },
                'choice_label' => function (TranslationLocale $locale) {
                    return $this->countryList->getLanguageByLocale($locale->getCode());
                },
                'label' => 'account.settings.language',
                'attr' => [
                    'class' => 'select'
                ]
            ])
            ->add('dateFormat', ChoiceType::class , [
                'choices' => [
                    'DD-MM-YYYY' => 0,
                    'MM-DD-YYYY' => 1,
                    'YYYY-MM-DD' => 2,
                    'DD-MMM-YYYY' => 3
                ],
                'label' => 'account.settings.date_format',
                'attr' => [
                    'class' => 'select'
                ]
            ])
            ->add('client', ClientType::class, [
                'validation_groups' => 'profile_validation',
                'constraints' => [
                    new Valid()
                ]
            ]);

        $builder->addEventSubscriber($this->subscriber);
    }

    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefaults([
            'data_class' => User::class,
            'translation_domain' => 'labels',
            'validation_groups' => 'profile_validation'
        ]);
    }
}