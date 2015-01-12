<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">

<!-- Latest compiled and minified JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
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
                            <li role="presentation"><a href="#tab_{$subsectionName}" aria-controls="settings" role="tab" data-toggle="tab">{$subsectionName|upfirst}</a></li>
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
                        <div role="tabpanel" class="tab-pane{if $cpt|eq(0)} active{/if}" id="tab_{$subsectionName}">
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
{/if}