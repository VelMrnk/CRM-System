<?php

namespace App\Form\Translation;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\CollectionType;
use Symfony\Component\Form\FormBuilderInterface;

class KeysCollection extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder->add('keys', CollectionType::class, [
            'entry_type' => KeyType::class
        ]);
    }
}