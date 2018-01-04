<?php
namespace Masev\SettingsBundle\Purger;

/**
 * Interface PurgeInterface
 * @package Masev\SettingsBundle\Purger
 */
interface PurgerInterface
{
    public function purgeAll();

    public function flush();
}