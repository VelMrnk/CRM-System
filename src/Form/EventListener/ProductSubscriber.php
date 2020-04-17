<?php

namespace App\Form\EventListener;

use App\Entity\ClientPlants;
use App\Manager\ProductManager;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\Extension\Core\Type\NumberType;
use Symfony\Component\Form\FormEvent;
use Symfony\Component\Form\FormEvents;
use Symfony\Component\Form\FormFactoryInterface;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\Form\FormInterface;
use Symfony\Component\Validator\Constraints\NotNull;
use Symfony\Contracts\Translation\TranslatorInterface;

class ProductSubscriber implements EventSubscriberInterface
{
    private $factory;

    public $manager;

    private $translator;

    public function __construct(FormFactoryInterface $factory, ProductManager $manager, TranslatorInterface $translator) {
        $this->factory = $factory;
        $this->manager = $manager;
        $this->translator = $translator;
    }

    public static function getSubscribedEvents()
    {
        return [
            FormEvents::POST_SET_DATA => 'postSet',
            FormEvents::PRE_SUBMIT => 'preSubmit',
        ];
    }

    /**
     * @param FormEvent $event
     */
    public function postSet(FormEvent $event)
    {
        $data = $event->getData();
        $form = $event->getForm();

        $form->add('category', ChoiceType::class , [
            'choices' => [
                $this->translator->trans('customer.customer', [], 'labels') => 1,
                $this->translator->trans('product.vendor_eatery', [], 'labels') => 2,
                $this->translator->trans('product.vendor_market', [], 'labels') => 3,
            ],
            'attr' => [
                'class' => 'select',
            ],
            'label' => 'product.category',
            'label_attr' => [
                'class' => 'col-md-2 col-sm-3 col-xs-5 control-label'
            ],
            'placeholder' => ''
        ]);

        if ($data) {
            if ($data->getCategory() == 1 && $data->isPos()) {
                $form->remove('plant');
                $form->remove('weight');
                $this->addPayBy($event->getForm());

                $data->setWeight(null);
            } else {
                $this->addWeight($form);

                $form->remove('payByItem');
                $data->setPayByItem(false);
            }

            $event->setData($data);
        }
    }

    /**
     * @param FormEvent $event
     */
    public function preSubmit(FormEvent $event)
    {
        $data = $event->getData();
        $form = $event->getForm();

        if ($data) {
            if (isset($data['category']) && $data['category'] == 1 && isset($data['isPos']) && $data['isPos'] == true) {
                $form->remove('plant');
                $form->remove('weight');
                $this->addPayBy($event->getForm());

                unset($data['plant']);
                unset($data['weight']);
            } else {
                $this->addWeight($event->getForm());
                $form->remove('payByItem');

                unset($data['payByItem']);
            }

            $event->setData($data);
        }
    }

    /**
     * @param FormInterface $form
     */
    public function addWeight(FormInterface $form)
    {
        $label = $this->translator->trans('product.product_weight', [
            '%format%' => $form->getConfig()->getOptions()['client']->getWeightName()
        ], 'labels');

        $form->add('weight', NumberType::class, [
            'attr' => [
                'class' => 'form-control',
                'placeholder' => $label
            ],
            'label' => $label,
            'label_attr' => [
                'class' => 'col-md-2 col-sm-3 col-xs-5 control-label'
            ],
            'required' => false
        ]);
    }

    /**
     * @param FormInterface $form
     */
    public function addPayBy(FormInterface $form)
    {
        $form->add('payByItem', ChoiceType::class , [
            'choices' => [
                'product.item' => 1,
                'product.weight' => 0
            ],
            'label' => 'product.pay_by',
            'label_attr' => [
                'class' => 'col-md-2 col-sm-3 col-xs-5 control-label'
            ],
            'choice_attr' => function() {
                return [
                    'class' => 'styled'
                ];
            },
            'expanded' => true
        ]);
    }
}