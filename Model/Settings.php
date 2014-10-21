<?php

namespace Masev\SettingsBundle\Model;

use Doctrine\Common\Proxy\Exception\InvalidArgumentException;
use Symfony\Component\Console\Application;
use Symfony\Component\DependencyInjection\Container;
use Symfony\Component\DependencyInjection\ContainerAwareInterface;
use Symfony\Component\DependencyInjection\ContainerBuilder;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Symfony\Component\HttpKernel\Kernel;
use Masev\SettingsBundle\Dal\ParametersStorageInterface;
use Masev\SettingsBundle\DependencyInjection\ContainerInjectionManager;

class Settings implements ContainerAwareInterface
{
    /**
     * @var ParametersStorageInterface
     */
    private $parametersStorage;

    /**
     * @var ContainerInjectionManager
     */
    private $containerInjectionManager;

    /**
     * @var ContainerInterface
     */
    private $container;

    private $schema;

    private $keyDict;

    private $data;

    public function __construct(ParametersStorageInterface $parametersStorage, ContainerInjectionManager $containerInjectionManager, $schema)
    {
        $this->parametersStorage         = $parametersStorage;
        $this->containerInjectionManager = $containerInjectionManager;
        $this->schema                    = $schema;
        $this->data                      = array();
        $this->keyDict                   = array();

        foreach ($this->schema as $id => $setting) {
            $this->keyDict[$setting['key']] = $id;
        }
    }

    /**
     * Sets the Container.
     *
     * @param ContainerInterface|null $container A ContainerInterface instance or null
     *
     * @api
     */
    public function setContainer(ContainerInterface $container = null)
    {
        $this->container = $container;
    }


    public function keyExistInSchema($key) {
        return array_key_exists($key, $this->keyDict);
    }

    /**
     * @return mixed
     */
    public function getSchema()
    {
        return $this->schema;
    }

    public function __set($name, $value)
    {
        if (!array_key_exists($name, $this->schema)) {
            trigger_error(sprintf('Property %s does not exist in dynamic settings.', $name));
        }

        return $this->data[$name] = $value;
    }

    /**
     * Save current model in the storage
     */
    public function save($scope = 'default')
    {
        foreach ($this->data as $key => $value) {
            if (!is_null($value)) {
                $this->parametersStorage->set($key, $value, $scope);
            } else {
                // Remove value to use default
                $this->parametersStorage->remove($key, $scope);
            }
        }
    }

    /**
     * @return array
     */
    public function getDataAsArray($scope = null)
    {
        $data = array();

        foreach ($this->schema as $param) {
            if (!is_null($scope)) {
                $data[$param['key']] = array(
                    "data" => $this->parametersStorage->get($param['key'], $scope),
                    "schema" => $param
                );
            } else {
                $data[$param['key']] = array(
                    "data" => $this->parametersStorage->getAll($param['key']),
                    "schema" => $param
                );
            }
        }

        return $data;
    }

    public function getSections()
    {
        $sections = array();
        foreach ($this->schema as $key => $setting) {
            $settingExploded = explode(".", $key);

            if (count($settingExploded) > 3) {
                $sections[$settingExploded[0]][$settingExploded[1]][$settingExploded[2]] = false;
            } elseif (count($settingExploded) > 2) {
                $sections[$settingExploded[0]][$settingExploded[1]] = false;
            } else {
                $sections[$settingExploded[0]] = false;
            }
        }

        return $sections;
    }
}