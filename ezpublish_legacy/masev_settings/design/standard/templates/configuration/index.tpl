<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
<link href="/extension/masev_settings/design/standard/stylesheets/xeditable.css" rel="stylesheet">

<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.10/angular.min.js"></script>
<script src="/extension/masev_settings/design/standard/javascript/app.js"></script>
<script src="/extension/masev_settings/design/standard/javascript/xeditable.js"></script>

{literal}
<style type="text/css">
    #leftmenu {
        display: none !important;
    }

    #maincontent {
        margin-left: 25px !important;
    }

    #left-panels-separator {
        left: 0px !important;
    }

    .dropdown {
        display: inline;
    }

    div.tab-content {
        height: 100%;
    }

    #submitButton {
        margin-top:15px;
    }
</style>
<script>
    $(function () {
        $('[data-toggle="tooltip"]').tooltip()
    })
</script>
{/literal}

<div ng-app="masevSettings">
    {literal}
    <div ng-controller="SettingsController as settings">
        <div ng-hide="settings.xhrCount >= 2" style="position: absolute;background-color: #FFF;width: 100%;margin: 0;height: 100%; z-index: 9999; text-align: center;">
            <img style="margin-top: 50px;" src="/extension/masev_settings/design/standard/images/loading.gif" width="100px" />
        </div>
        <div role="tabpanel">
            <!-- Nav tabs -->
            <ul class="nav nav-tabs" role="tablist">
                <li ng-repeat="(level1, level2_sections) in settings.sections" role="presentation" class="dropdown" ng-class="{active: $index === 0}">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-expanded="false">
                        {{ level1 }} <span class="caret"></span>
                    </a>
                    <ul class="dropdown-menu" role="menu">
                        <li ng-repeat="(level2, value) in level2_sections" role="presentation"><a href="#tab_{{level1}}_{{level2}}" aria-controls="settings" role="tab" data-toggle="tab">{{ level2 }}</a></li>
                    </ul>
                </li>
            </ul>

            <!-- Tab panes -->
            <div class="tab-content">
                <div ng-repeat="(key, level2_section) in settings.level2_sections" role="tabpanel" ng-class="{active: $index === 0}" class="tab-pane" id="tab_{{level2_section.level1}}_{{level2_section.name}}">
                    <h2>{{ level2_section.name }} <small>{{ level2_section.level1 }}</small></h2>

                    <div ng-repeat="(key, item) in settings.data" class="form-group">
                        <label ng-show="item.schema.key.indexOf(level2_section.name) > -1 && item.schema.key.indexOf(level2_section.level1) > -1" for="{{ key }}">{{ item.schema.name }} :</label>
                        <span ng-show="item.schema.key.indexOf(level2_section.name) > -1 && item.schema.key.indexOf(level2_section.level1) > -1" id="{$key}" editable-text="item.data" onbeforesave="updateSettings(item, $data)" >{{ item.data == "" ? "Empty value, example : "+item.schema.default : item.data }}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    {/literal}
{#
    <div class="box-header"><div class="box-ml">
            <h1 class="context-title">{'Settings'|i18n('masev_settings')}
                {if ezhttp_hasvariable('site', 'get')}
                <div class="dropdown">
                    <button class="btn btn-default dropdown-toggle" type="button" id="dropdownSiteMenu" data-toggle="dropdown" aria-expanded="true">
                        {ezhttp('site', 'get')}
                        <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                        <li role="presentation"><a role="menuitem" tabindex="-1" href="?site=default" data-toggle="tooltip" data-placement="top" title="{'Default apply on all site except if a site has already a value defined'|i18n('masev_settings')}">Default</a></li>
                        {foreach ezini('SiteSettings', 'SiteList') as $site}
                            <li role="presentation"><a role="menuitem" tabindex="-1" href="?site={$site}">{$site}</a></li>
                        {/foreach}
                    </ul>
                </div>
                {/if}
            </h1>
            <div class="header-mainline"></div>
    </div></div>

    {if ezhttp_hasvariable('site', 'get')|not}
        <div class="panel panel-default">
            <div class="panel-body">
                <form method="get">
                    {'Please select a site to access configuration'|i18n('masev_settings')}
                    <div class="dropdown">
                        <button class="btn btn-default dropdown-toggle" type="button" id="dropdownSiteMenu" data-toggle="dropdown" aria-expanded="true">
                            {'Site list'|i18n('masev_settings')}
                            <span class="caret"></span>
                        </button>
                        <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                            <li role="presentation" data-toggle="tooltip" data-placement="top" title="{'Default apply on all site except if a site has already a value defined'|i18n('masev_settings')}"><a role="menuitem" tabindex="-1" href="?site=default">Default</a></li>
                            {foreach ezini('SiteSettings', 'SiteList') as $site}
                                <li role="presentation"><a role="menuitem" tabindex="-1" href="?site={$site}">{$site}</a></li>
                            {/foreach}
                        </ul>
                    </div>
                </form>
            </div>
        </div>
    {else}

        {if is_set($success)}
            <div class="alert alert-success alert-dismissible" role="alert">
                {'Your settings are saved !'|i18n('masev_settings')}
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
        {/if}

        <div role="tabpanel">
            <!-- Nav tabs -->
            <ul class="nav nav-tabs" role="tablist">
                {def $cpt = 0}
                {foreach $sections as $sectionName => $subsection}
                    <li role="presentation" class="dropdown {if $cpt|eq(0)}active{/if}">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-expanded="false">
                            {$sectionName|upfirst} <span class="caret"></span>
                        </a>
                        <ul class="dropdown-menu" role="menu">
                            {foreach $subsection as $subsectionName => $subsection}
                                <li role="presentation"><a href="#tab_{$sectionName}_{$subsectionName}" aria-controls="settings" role="tab" data-toggle="tab">{$subsectionName|upfirst}</a></li>
                            {/foreach}
                        </ul>
                    </li>
                    {set $cpt = $cpt|inc}
                {/foreach}
            </ul>

            <!-- Tab panes -->
            <form method="post" action="">
                <div class="tab-content">
                    {def $cpt = 0}
                    {foreach $sections as $sectionName => $subsection}
                        {foreach $subsection as $subsectionName => $subsection}
                            <div role="tabpanel" class="tab-pane{if $cpt|eq(0)} active{/if}" id="tab_{$sectionName}_{$subsectionName}">
                                <h2>{$subsectionName|upfirst} <small>{$sectionName|upfirst}</small></h2>
                                {foreach $data as $key => $item}
                                    {if and($key|contains($sectionName), $key|contains($subsectionName))}
                                        <div class="form-group">
                                            <label for="{$key}">{$item.schema.name} :</label>
                                            <input class="form-control" id="{$key}" name="config[{$key}]" type="text" value="{$item.data}" placeholder="{$item.schema.default}">
                                        </div>
                                    {/if}
                                {/foreach}
                            </div>
                            {set $cpt = $cpt|inc}
                        {/foreach}
                    {/foreach}
                </div>

                <div class="row">
                    <div class="col-md-4">
                        <input type="submit" class="btn btn-primary btn-lg" name="SaveConfigButton" id="submitButton" value="{'Save changes'|i18n('masev_settings')}" data-toggle="tooltip" data-placement="top" title="{'This will clear all the cache !'|i18n('masev_settings')}" />
                    </div>
                </div>
            </form>
        </div>
    {/if} #}
</div>