---
layout: page
title: "Posts"
nav: posts
---

Posts front page

{% for post in site.posts limit: 5 %}
{% if post.categories contains 'posts' %}
<article>
	<header>
		<h1><a href="{{ post.url }}">{{ post.title }}</a></h1>
	</header>
	<p>{{ post.content }}</p>
</article>
{% endif %}
{% endfor %}