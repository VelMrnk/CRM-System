<?php

namespace App\Form\Client;

use App\Entity\Client\Client;
use App\Form\EventListener\OwnerLocationSubscriber;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\Extension\Core\Type\TextType;

use MenaraSolutions\Geographer\Earth;

class ClientNameType extends AbstractType
{
    /**
     * @param FormBuilderInterface $builder
     * @param array $options
     */
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('name', TextType::class, [
                'translation_domain' => 'messages',
                'required' => false,
                'attr' => [
                    'class' => 'form-control',
                    'placeholder' => 'register.company_name'
                ]
            ]);
    }


    /**
     * @param OptionsResolver $resolver
     */
    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefaults([
            'data_class' => Client::class,
            'validation_groups' => ['register_validation']
        ]);
    }

    public function getName()
    {
        return 'client';
    }

}
