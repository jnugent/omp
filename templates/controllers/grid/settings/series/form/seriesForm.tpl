{**
 * templates/controllers/grid/settings/series/form/seriesForm.tpl
 *
 * Copyright (c) 2014-2016 Simon Fraser University Library
 * Copyright (c) 2003-2016 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Series form under press management.
 *}

<script type="text/javascript">
	$(function() {ldelim}
		// Attach the form handler.
		$('#seriesForm').pkpHandler(
			'$.pkp.controllers.form.FileUploadFormHandler',
			{ldelim}
				publishChangeEvents: ['updateSidebar'],
				$uploader: $('#plupload'),
				uploaderOptions: {ldelim}
					uploadUrl: {url|json_encode op="uploadImage" escape=false},
					baseUrl: {$baseUrl|json_encode},
					filters: {ldelim}
						mime_types : [
							{ldelim} title : "Image files", extensions : "jpg,jpeg,png" {rdelim}
						]
					{rdelim}
				{rdelim}
			{rdelim}
		);
	{rdelim});
</script>

<form class="pkp_form" id="seriesForm" method="post" action="{url router=$smarty.const.ROUTE_COMPONENT component="grid.settings.series.SeriesGridHandler" op="updateSeries" seriesId=$seriesId}">
	{include file="controllers/notification/inPlaceNotification.tpl" notificationId="seriesFormNotification"}

	{fbvFormArea id="file"}
		{fbvFormSection title="monograph.coverImage"}
			{include file="controllers/fileUploadContainer.tpl" id="plupload"}
		{/fbvFormSection}
	{/fbvFormArea}
	{* Container for uploaded file *}
	<input type="hidden" name="temporaryFileId" id="temporaryFileId" value="" />

	{if $image}
		{translate|assign:"altTitle" key="monograph.currentCoverImage"}
		<img class="pkp_helpers_container_center" height="{$image.thumbnailHeight}" width="{$image.thumbnailWidth}" src="{url router=$smarty.const.ROUTE_PAGE page="catalog" op="thumbnail" type="series" id=$seriesId}" alt="{$altTitle|escape}" />
	{/if}

	{fbvFormArea id="seriesInfo"}
		<div class="pkp_helpers_clear">
			{fbvFormSection for="title" title="common.prefix" inline="true" size=$fbvStyles.size.SMALL}
				{fbvElement label="common.prefixAndTitle.tip" type="text" multilingual=true name="prefix" id="prefix" value=$prefix}
			{/fbvFormSection}
			{fbvFormSection for="title" title="common.title" inline="true" size=$fbvStyles.size.LARGE required=true}
				{fbvElement type="text" multilingual=true name="title" id="title" value=$title}
			{/fbvFormSection}
		</div>

		{fbvFormSection for="subtitle" title="common.subtitle"}
			{fbvElement label="common.subtitle.tip" type="text" multilingual=true name="subtitle" id="subtitle" value=$subtitle maxlength="255"}
		{/fbvFormSection}

		{fbvFormSection title="common.description" for="description"}
		 	{fbvElement type="textarea" multilingual=true id="description" value=$description rich=true}
		{/fbvFormSection}

		{fbvFormSection list="true"}
			{fbvElement type="checkbox" id="restricted" value=1 label="manager.series.restricted" checked=$restricted}
		{/fbvFormSection}

		{fbvFormSection label="catalog.manage.series.issn" description="manager.setup.issnDescription"}
			{fbvElement type="text" id="onlineIssn" label="catalog.manage.series.onlineIssn" value=$onlineIssn maxlength="16" size=$fbvStyles.size.MEDIUM inline=true}
			{fbvElement type="text" id="printIssn" label="catalog.manage.series.printIssn" value=$printIssn maxlength="16" size=$fbvStyles.size.MEDIUM inline=true}
		{/fbvFormSection}

		{fbvFormSection label="catalog.sortBy" description="catalog.sortBy.seriesDescription" for="sortOption"}
			{fbvElement type="select" id="sortOption" from=$sortOptions selected=$sortOption translate=false}
		{/fbvFormSection}

		<input type="hidden" name="seriesId" value="{$seriesId|escape}"/>
		{if $categoryCount > 0}
			{fbvFormSection for="context"}
				<div id="seriesCategoriesContainer">
					{url|assign:seriesCategoriesUrl router=$smarty.const.ROUTE_COMPONENT component="listbuilder.settings.CategoriesListbuilderHandler" op="fetch" sectionId=$seriesId escape=false}
					{load_url_in_div id="seriesCategoriesContainer" url=$seriesCategoriesUrl}
				</div>
			{/fbvFormSection}
		{/if}

		{fbvFormSection for="context"}
			{if $seriesEditorCount > 0}{* only include the series editor listbuilder if there are series editors available *}
				<div id="seriesEditorsContainer">
					{url|assign:seriesEditorsUrl router=$smarty.const.ROUTE_COMPONENT component="listbuilder.settings.SubEditorsListbuilderHandler" op="fetch" sectionId=$seriesId escape=false}
					{load_url_in_div id="seriesEditorsContainer" url=$seriesEditorsUrl}
				</div>
			{/if}
		{/fbvFormSection}

		{capture assign="instruct"}
			{url|assign:"sampleUrl" router=$smarty.const.ROUTE_PAGE page="catalog" op="series" path="Path"}
			{translate key="grid.series.urlWillBe" sampleUrl=$sampleUrl}
		{/capture}
		{fbvFormSection title="series.path" required=true for="path"}
			{fbvElement type="text" id="path" label=$instruct subLabelTranslate=false value=$path maxlength="32"}
		{/fbvFormSection}
	{/fbvFormArea}

	{fbvFormButtons submitText="common.save"}
</form>
<p><span class="formRequired">{translate key="common.requiredField"}</span></p>
