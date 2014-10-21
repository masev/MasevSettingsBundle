<div class="box-header"><div class="box-ml">
        <h1 class="context-title">Configuration {if and(ezhttp_hasvariable('site', 'get'), ezhttp('site', 'get')|ne('default'))}de {ezhttp('site', 'get')}{else}par défaut{/if}</h1>
        <div class="header-mainline"></div>
</div></div>

<form method="get">
    <div id="controlbar-top" class="controlbar">
        <div class="box-bc"><div class="box-ml">
            <div class="button-left">
                <select name="site">
                    <option value="default">Default</option>
                    {foreach ezini('SiteSettings', 'SiteList') as $site}
                        <option {if ezhttp('site', 'get')|eq($site)}selected="selected"{/if} value="{$site}">{$site}</option>
                    {/foreach}
                </select>
                <input type="submit" class="button" value="Changer de site">
            </div>
            <div class="float-break"></div>
        </div></div>
    </div>
</form>

<div class="block">
    <form method="post" action="">
        {foreach $sections as $sectionName => $subsection}
            <h2>{$sectionName|upfirst}</h2>
            {foreach $subsection as $subsectionName => $subsection}
                <fieldset style="margin-top: 20px;">
                    <legend>{$subsectionName|upfirst}</legend>
                    {foreach $data as $key => $item}
                        {if and($key|contains($sectionName), $key|contains($subsectionName))}
                        <div class="block">
                            <label for="{$key}">{$item.schema.name} :</label>
                            <input class="box" id="{$key}" name="config[{$key}]" type="text" value="{$item.data}" placeholder="{$item.schema.default}">
                        </div>
                        {/if}
                    {/foreach}
                </fieldset>
            {/foreach}
        {/foreach}

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
</div>