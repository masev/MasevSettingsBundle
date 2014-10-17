<?php

namespace Masev\SettingsBundle\Twig;

class MasevExtension extends \Twig_Extension
{
    private $configResolver;

    public function __construct($configResolver) {
        $this->configResolver = $configResolver;
    }

    public function getFunctions() {
        return array(
            'getMasevSettings' => new \Twig_Function_Method($this, 'getMasevSettings')
        );
    }

    public function getMasevSettings($key)
    {
        if (!$this->configResolver->hasParameter($key, 'masev_settings')) {
            return false;
        }

        return $this->configResolver->getParameter($key, 'masev_settings');
    }

    public function getName()
    {
        return 'masev_extension';
    }
}