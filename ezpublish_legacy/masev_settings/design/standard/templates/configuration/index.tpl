{foreach $data as $item}
    <h4>{$item.schema.name} :</h4>
    <ul>
    {foreach $item.data as $scopedData}
        <li>{$scopedData.scope} : {$scopedData.value}</li>
    {/foreach}
    </ul>
{/foreach}