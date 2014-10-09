<?php

namespace Masev\SettingsBundle\DependencyInjection;

use eZ\Bundle\EzPublishCoreBundle\DependencyInjection\Configuration\SiteAccessAware\ConfigurationProcessor;
use eZ\Bundle\EzPublishCoreBundle\DependencyInjection\Configuration\SiteAccessAware\ContextualizerInterface;
use Symfony\Component\Config\ConfigCache;
use Symfony\Component\DependencyInjection\ContainerBuilder;
use Symfony\Component\HttpKernel\Kernel;
use Masev\SettingsBundle\Dal\ParametersStorageInterface;

class ContainerInjectionManager
{
    private $parametersPrefix;

    protected $parametersStorage;

    protected $schema;

    public function __construct(ParametersStorageInterface $parametersStorage, $schema, $parametersPrefix)
    {
        $this->parametersStorage = $parametersStorage;
        $this->schema            = $schema;
        $this->parametersPrefix  = $parametersPrefix;
    }

    /**
     * Inject dynamic parameters in the container builder
     *
     * @param ContainerBuilder $container
     */
    public function inject(ContainerBuilder $container)
    {
        foreach ($this->schema as $parameter) {

            $config = array(
                'system' => array(
                    'default' => array(
                        $parameter['key'] => $parameter['default']
                    )
                )
            );

            if ($this->parametersStorage->has($parameter['key'])) {
                $values = $this->parametersStorage->getAll($parameter['key']);
                foreach ($values as $value) {
                    $config['system'][$value['scope']] = array($parameter['key'] => $value['value']);
                }
            }

            $processor = new ConfigurationProcessor( $container, 'masev_settings' );

            $processor->mapConfig(
                          $config,
                          // Any kind of callable can be used here.
                          // It will be called for each declared scope/SiteAccess.
                          function ( $scopeSettings, $currentScope, ContextualizerInterface $contextualizer )
                          {
                              // Will map "hello" setting to "acme_demo.<$currentScope>.hello" container parameter
                              // It will then be possible to retrieve this parameter through ConfigResolver in the application code:
                              // $helloSetting = $configResolver->getParameter( 'hello', 'acme_demo' );
                              $settingsKey = key($scopeSettings);
                              $contextualizer->setContextualParameter( $settingsKey, $currentScope, $scopeSettings[$settingsKey] );
                          }
            );
        }
    }

    /**
     * Rebuild the container and dump it to the cache to apply change on redis stored parameters
     */
    public function rebuild(Kernel $kernel)
    {
        $kernelReflectionClass = new \ReflectionClass($kernel);

        $buildContainerReflectionMethod = $kernelReflectionClass->getMethod('buildContainer');
        $buildContainerReflectionMethod->setAccessible(true);

        $dumpContainerReflectionMethod = $kernelReflectionClass->getMethod('dumpContainer');
        $dumpContainerReflectionMethod->setAccessible(true);

        $getContainerClassReflectionMethod = $kernelReflectionClass->getMethod('getContainerClass');
        $getContainerClassReflectionMethod->setAccessible(true);

        $getContainerBaseClassReflectionMethod = $kernelReflectionClass->getMethod('getContainerBaseClass');
        $getContainerBaseClassReflectionMethod->setAccessible(true);

        /** @var ContainerBuilder $newContainer */
        $newContainer = $buildContainerReflectionMethod->invoke($kernel);

        $this->inject($newContainer);

        $newContainer->compile();

        $class = $getContainerClassReflectionMethod->invoke($kernel);
        $cache = new ConfigCache($kernel->getCacheDir() . '/' . $class . '.php', $kernel->isDebug());
        $dumpContainerReflectionMethod->invoke($kernel, $cache, $newContainer, $class, $getContainerBaseClassReflectionMethod->invoke($kernel));
    }
}