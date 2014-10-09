<?php

namespace Masev\SettingsBundle\DependencyInjection;

use Symfony\Component\Config\Definition\Builder\TreeBuilder;
use Symfony\Component\Config\Definition\ConfigurationInterface;

class Configuration implements ConfigurationInterface
{
    private $bundles;

    /**
     * Constructor
     *
     * @param array $bundles An array of bundle names
     */
    public function __construct(array $bundles)
    {
        $this->bundles = $bundles;
    }

    /**
     * {@inheritDoc}
     */
    public function getConfigTreeBuilder()
    {
        $treeBuilder = new TreeBuilder();
        $rootNode = $treeBuilder->root('masev_settings');

        $rootNode
            ->addDefaultsIfNotSet()
            ->children()
            ->scalarNode('config_file_parser')->defaultValue('\Masev\SettingsBundle\Parser\XmlFileLoader')->end()
            ->arrayNode('mysql')
            ->info('mysql access')
            ->children()
            ->scalarNode('host')->defaultValue('localhost')->isRequired()->end()
            ->scalarNode('user')->defaultValue("")->isRequired()->end()
            ->scalarNode('password')->defaultValue("")->isRequired()->end()
            ->scalarNode('dbname')->defaultValue("settings")->isRequired()->end()
            ->end()
            ->end()
            ->arrayNode('bundles')
            ->defaultValue($this->bundles)
            ->prototype('scalar')
            ->validate()
            ->ifNotInArray($this->bundles)
            ->thenInvalid('%s is not a valid bundle.')
            ->end()
            ->end()
            ->end();


        return $treeBuilder;
    }
}