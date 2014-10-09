<?php

namespace Masev\SettingsBundle\Parser;

/**
 * Interface ParserInterface
 */
interface ParserInterface
{
    /**
     * @param $file
     * @param null $type
     * @return mixed
     */
    public function load($file);

    /**
     * @param $resource
     * @return mixed
     */
    public function supports($resource);
} 