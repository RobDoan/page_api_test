object @page
extends("api/pages/show")
node(:total_word) { total_word(@page.content)}
