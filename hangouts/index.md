---
layout: page
title: "Hangouts"
nav: hangouts
---

Hangouts page

{% for post in site.posts limit: 5 %}
{% if post.categories contains 'hangouts' %}
<article>
	<header>
		<h1><a href="{{ post.url }}">{{ post.title }}</a></h1>
	</header>
	<p>{{ post.content }}</p>
</article>
{% endif %}
{% endfor %}