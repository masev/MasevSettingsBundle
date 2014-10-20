<div class="box-header"><div class="box-ml">
        <h1 class="context-title">Configuration {if and(ezhttp_hasvariable('site', 'get'), ezhttp('site', 'get')|ne('default'))}de {ezhttp('site', 'get')}{else}par défaut{/if}</h1>
        <div class="header-mainline"></div>
</div></div>

<form method="get">
    <p>
        <select name="site">
            <option value="default">Default</option>
            {foreach ezini('SiteSettings', 'SiteList') as $site}
                <option {if ezhttp('site', 'get')|eq($site)}selected="selected"{/if} value="{$site}">{$site}</option>
            {/foreach}
        </select>
        <input type="submit" class="button" value="Changer de site">
    </p>
</form>

<form method="post" action="">
    <div class="block">
        {foreach $data as $key => $item}
            <div class="block">
                <label for="{$key}">{$item.schema.name} :</label>
                <input class="box" id="{$key}" name="config[{$key}]" type="text" value="{$item.data}" placeholder="{$item.schema.default}">
            </div>
        {/foreach}
    </div>

    <div class="block">
        <div class="controlbar">
            <div class="box-bc">
                <div class="block">
                    <input type="submit" class="defaultbutton" name="SaveConfigButton" value="Sauvegarder les paramètres">
                </div>
            </div>
        </div>
    </div>
</form>