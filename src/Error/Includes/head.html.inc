const

STR_HEAD_HTML =
    '<!DOCTYPE HTML>' + LineEnding +
    '<!--' + LineEnding +
    '	Hyperspace by HTML5 UP' + LineEnding +
    '	html5up.net | @ajlkn' + LineEnding +
    '	Free for personal and commercial use under the CCA 3.0 license (html5up.net/license)' + LineEnding +
    '-->' + LineEnding +
    '<html>' + LineEnding +
    '	<head>' + LineEnding +
    '		<title>Fano Application Error</title>' + LineEnding +
    '		<meta charset="utf-8" />' + LineEnding +
    '		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />' + LineEnding +
    '		<style>' + LineEnding +
    '	html, body, div, span, applet, object,' + LineEnding +
    '	iframe, h1, h2, h3, h4, h5, h6, p, blockquote,' + LineEnding +
    '	pre, a, abbr, acronym, address, big, cite,' + LineEnding +
    '	code, del, dfn, em, img, ins, kbd, q, s, samp,' + LineEnding +
    '	small, strike, strong, sub, sup, tt, var, b,' + LineEnding +
    '	u, i, center, dl, dt, dd, ol, ul, li, fieldset,' + LineEnding +
    '	form, label, legend, table, caption, tbody,' + LineEnding +
    '	tfoot, thead, tr, th, td, article, aside,' + LineEnding +
    '	canvas, details, embed, figure, figcaption,' + LineEnding +
    '	footer, header, hgroup, menu, nav, output, ruby,' + LineEnding +
    '	section, summary, time, mark, audio, video {' + LineEnding +
    '		margin: 0;' + LineEnding +
    '		padding: 0;' + LineEnding +
    '		border: 0;' + LineEnding +
    '		font-size: 100%;' + LineEnding +
    '		font: inherit;' + LineEnding +
    '		vertical-align: baseline;}' + LineEnding +
    '	article, aside, details, figcaption, figure,' + LineEnding +
    '	footer, header, hgroup, menu, nav, section {' + LineEnding +
    '		display: block;}' + LineEnding +
    '	body {' + LineEnding +
    '		line-height: 1;' + LineEnding +
    '	}' + LineEnding +
    '	ol, ul {' + LineEnding +
    '		list-style: none;' + LineEnding +
    '	}' + LineEnding +
    '	body {' + LineEnding +
    '		-webkit-text-size-adjust: none;' + LineEnding +
    '	}' + LineEnding +
    '		@-ms-viewport {' + LineEnding +
    '			width: device-width;' + LineEnding +
    '		}' + LineEnding +
    '		body {' + LineEnding +
    '			-ms-overflow-style: scrollbar;' + LineEnding +
    '		}' + LineEnding +
    '		@media screen and (max-width: 480px) {' + LineEnding +
    '			html, body {' + LineEnding +
    '				min-width: 320px;' + LineEnding +
    '			}' + LineEnding +
    '		}' + LineEnding +
    '		html {' + LineEnding +
    '			box-sizing: border-box;' + LineEnding +
    '		}' + LineEnding +
    '		*, *:before, *:after {' + LineEnding +
    '			box-sizing: inherit;' + LineEnding +
    '		}' + LineEnding +
    '		body {' + LineEnding +
    '			background: #312450;' + LineEnding +
    '		}' + LineEnding +
    '			body.is-preload *, body.is-preload *:before, body.is-preload *:after {' + LineEnding +
    '				-moz-animation: none !important;' + LineEnding +
    '				-webkit-animation: none !important;' + LineEnding +
    '				-ms-animation: none !important;' + LineEnding +
    '				animation: none !important;' + LineEnding +
    '				-moz-transition: none !important;' + LineEnding +
    '				-webkit-transition: none !important;' + LineEnding +
    '				-ms-transition: none !important;' + LineEnding +
    '				transition: none !important;' + LineEnding +
    '			}' + LineEnding +
    '		body, input, select, textarea {' + LineEnding +
    '			color: rgba(255, 255, 255, 0.55);' + LineEnding +
    '			font-family: Arial, Helvetica, sans-serif;' + LineEnding +
    '			font-size: 16.5pt;' + LineEnding +
    '			font-weight: normal;' + LineEnding +
    '			line-height: 1.75;' + LineEnding +
    '		}' + LineEnding +
    '		@media screen and (max-width: 1680px) {' + LineEnding +
    '			body, input, select, textarea {' + LineEnding +
    '				font-size: 13pt;' + LineEnding +
    '			}' + LineEnding +
    '		}' + LineEnding +
    '		@media screen and (max-width: 1280px) {' + LineEnding +
    '			body, input, select, textarea {' + LineEnding +
    '				font-size: 12pt;' + LineEnding +
    '			}' + LineEnding +
    '		}' + LineEnding +
    '			@media screen and (max-width: 360px) {' + LineEnding +
    '				body, input, select, textarea {' + LineEnding +
    '					font-size: 11pt;' + LineEnding +
    '				}' + LineEnding +
    '			}' + LineEnding +
    '		a {' + LineEnding +
    '			-moz-transition: color 0.2s ease, border-bottom-color 0.2s ease;' + LineEnding +
    '			-webkit-transition: color 0.2s ease, border-bottom-color 0.2s ease;' + LineEnding +
    '			-ms-transition: color 0.2s ease, border-bottom-color 0.2s ease;' + LineEnding +
    '			transition: color 0.2s ease, border-bottom-color 0.2s ease;' + LineEnding +
    '			border-bottom: dotted 1px rgba(255, 255, 255, 0.35);' + LineEnding +
    '			color: inherit;' + LineEnding +
    '			text-decoration: none;' + LineEnding +
    '		}' + LineEnding +
    '			a:hover {' + LineEnding +
    '				border-bottom-color: transparent;' + LineEnding +
    '				color: #ffffff;' + LineEnding +
    '			}' + LineEnding +
    '		strong, b {' + LineEnding +
    '			color: #ffffff;' + LineEnding +
    '			font-weight: bold;' + LineEnding +
    '		}' + LineEnding +
    '		em, i {' + LineEnding +
    '			font-style: italic;' + LineEnding +
    '		}' + LineEnding +
    '		p {' + LineEnding +
    '			margin: 0 0 2em 0;' + LineEnding +
    '		}' + LineEnding +
    '		h1, h2, h3, h4, h5, h6 {' + LineEnding +
    '			color: #ffffff;' + LineEnding +
    '			font-weight: bold;' + LineEnding +
    '			line-height: 1.5;' + LineEnding +
    '			margin: 0 0 0.5em 0;' + LineEnding +
    '		}' + LineEnding +
    '		h1 a, h2 a, h3 a, h4 a, h5 a, h6 a {' + LineEnding +
    '			color: inherit;' + LineEnding +
    '			text-decoration: none;' + LineEnding +
    '		}' + LineEnding +
    '		h1 {' + LineEnding +
    '			font-size: 2.75em;' + LineEnding +
    '		}' + LineEnding +
    '		h2 {' + LineEnding +
    '			font-size: 1.75em;' + LineEnding +
    '		}' + LineEnding +
    '		h3 {' + LineEnding +
    '			font-size: 1.1em;' + LineEnding +
    '		}' + LineEnding +
    '		h4 {' + LineEnding +
    '			font-size: 1em;' + LineEnding +
    '		}' + LineEnding +
    '		h5 {' + LineEnding +
    '			font-size: 0.8em;' + LineEnding +
    '		}' + LineEnding +
    '		h6 {' + LineEnding +
    '			font-size: 0.6em;' + LineEnding +
    '		}' + LineEnding +
    '		@media screen and (max-width: 736px) {' + LineEnding +
    '			h1 {' + LineEnding +
    '				font-size: 2em;' + LineEnding +
    '			}' + LineEnding +
    '			h2 {' + LineEnding +
    '				font-size: 1.25em;' + LineEnding +
    '			}' + LineEnding +
    '			h3 {' + LineEnding +
    '				font-size: 1em;' + LineEnding +
    '			}' + LineEnding +
    '			h4 {' + LineEnding +
    '				font-size: 0.8em;' + LineEnding +
    '			}' + LineEnding +
    '			h5 {' + LineEnding +
    '				font-size: 0.6em;' + LineEnding +
    '			}' + LineEnding +
    '			h6 {' + LineEnding +
    '				font-size: 0.6em;' + LineEnding +
    '			}' + LineEnding +
    '		}' + LineEnding +
    '		code {' + LineEnding +
    '			background: rgba(255, 255, 255, 0.05);' + LineEnding +
    '			border-radius: 0.25em;' + LineEnding +
    '			border: solid 1px rgba(255, 255, 255, 0.15);' + LineEnding +
    '			font-family: "Courier New", monospace;' + LineEnding +
    '			font-size: 0.9em;' + LineEnding +
    '			margin: 0 0.25em;' + LineEnding +
    '			padding: 0.25em 0.65em;' + LineEnding +
    '		}' + LineEnding +
    '		pre {' + LineEnding +
    '			-webkit-overflow-scrolling: touch;' + LineEnding +
    '			font-family: "Courier New", monospace;' + LineEnding +
    '			font-size: 0.9em;' + LineEnding +
    '			margin: 0 0 2em 0;' + LineEnding +
    '		}' + LineEnding +
    '			pre code {' + LineEnding +
    '				display: block;' + LineEnding +
    '				line-height: 1.5em;' + LineEnding +
    '				padding: 1em 1.5em;' + LineEnding +
    '				overflow-x: auto;' + LineEnding +
    '			}' + LineEnding +
    '		ol {' + LineEnding +
    '			list-style: decimal;' + LineEnding +
    '			margin: 0 0 2em 0;' + LineEnding +
    '			padding-left: 1.25em;' + LineEnding +
    '		}' + LineEnding +
    '			ol li {' + LineEnding +
    '				padding-left: 0.25em;' + LineEnding +
    '			}' + LineEnding +
    '		ul {' + LineEnding +
    '			list-style: disc;' + LineEnding +
    '			margin: 0 0 2em 0;' + LineEnding +
    '			padding-left: 1em;' + LineEnding +
    '		}' + LineEnding +
    '			ul li {' + LineEnding +
    '				padding-left: 0.5em;' + LineEnding +
    '			}' + LineEnding +
    '			ul.alt {' + LineEnding +
    '				list-style: none;' + LineEnding +
    '				padding-left: 0;' + LineEnding +
    '			}' + LineEnding +
    '				ul.alt li {' + LineEnding +
    '					border-top: solid 1px rgba(255, 255, 255, 0.15);' + LineEnding +
    '					padding: 0.5em 0;' + LineEnding +
    '				}' + LineEnding +
    '					ul.alt li:first-child {' + LineEnding +
    '						border-top: 0;' + LineEnding +
    '						padding-top: 0;' + LineEnding +
    '					}' + LineEnding +
    '		header p {' + LineEnding +
    '			color: rgba(255, 255, 255, 0.35);' + LineEnding +
    '			position: relative;' + LineEnding +
    '			margin: 0 0 1.5em 0;' + LineEnding +
    '		}' + LineEnding +
    '		header h2 + p {' + LineEnding +
    '			font-size: 1.25em;' + LineEnding +
    '			margin-top: -1em;' + LineEnding +
    '			line-height: 1.5em;' + LineEnding +
    '		}' + LineEnding +
    '		header h3 + p {' + LineEnding +
    '			font-size: 1.1em;' + LineEnding +
    '			margin-top: -0.8em;' + LineEnding +
    '			line-height: 1.5em;' + LineEnding +
    '		}' + LineEnding +
    '		header h4 + p,' + LineEnding +
    '		header h5 + p,' + LineEnding +
    '		header h6 + p {' + LineEnding +
    '			font-size: 0.9em;' + LineEnding +
    '			margin-top: -0.6em;' + LineEnding +
    '			line-height: 1.5em;' + LineEnding +
    '		}' + LineEnding +
    '		.wrapper {' + LineEnding +
    '			position: relative;' + LineEnding +
    '		}' + LineEnding +
    '		.wrapper > .inner {' + LineEnding +
    '			padding: 1em 1em 1em 1em ;' + LineEnding +
    '			max-width: 100%;' + LineEnding +
    '			width: 75em;' + LineEnding +
    '		}' + LineEnding +
    '		@media screen and (max-width: 1680px) {' + LineEnding +
    '			.wrapper > .inner {' + LineEnding +
    '				padding: 1.5em 2em 1.5em 2em ;' + LineEnding +
    '			}' + LineEnding +
    '		}' + LineEnding +
    '' + LineEnding +
    '		@media screen and (max-width: 1280px) {' + LineEnding +
    '			.wrapper > .inner {' + LineEnding +
    '				width: 100%;' + LineEnding +
    '			}' + LineEnding +
    '		}' + LineEnding +
    '		@media screen and (max-width: 736px) {' + LineEnding +
    '			.wrapper > .inner {' + LineEnding +
    '				padding: 1em 1.5em 1em 1.5em ;' + LineEnding +
    '			}' + LineEnding +
    '		}' + LineEnding +
    '		.wrapper.alt {' + LineEnding +
    '			background-color: #261c3e;' + LineEnding +
    '		}' + LineEnding +
    '		.wrapper.style1 {' + LineEnding +
    '			background-color: #5e42a6;' + LineEnding +
    '		}' + LineEnding +
    '		.wrapper.style1-alt {' + LineEnding +
    '			background-color: #493382;' + LineEnding +
    '		}' + LineEnding +
    '		.wrapper.style2 {' + LineEnding +
    '			background-color: #5052b5;' + LineEnding +
    '		}' + LineEnding +
    '		.wrapper.style2-alt {' + LineEnding +
    '			background-color: #3e4094;' + LineEnding +
    '		}' + LineEnding +
    '		.wrapper.style3 {' + LineEnding +
    '			background-color: #b74e91;' + LineEnding +
    '		}' + LineEnding +
    '		.wrapper.style3-alt {' + LineEnding +
    '			background-color: #953d75;' + LineEnding +
    '		}' + LineEnding +
    '		#header {' + LineEnding +
    '			display: -moz-flex;' + LineEnding +
    '			display: -webkit-flex;' + LineEnding +
    '			display: -ms-flex;' + LineEnding +
    '			display: flex;' + LineEnding +
    '			background-color: #5e42a6;' + LineEnding +
    '			cursor: default;' + LineEnding +
    '			padding: 1.75em 2em;' + LineEnding +
    '		}' + LineEnding +
    '		#header > .title {' + LineEnding +
    '			border: 0;' + LineEnding +
    '			color: #ffffff;' + LineEnding +
    '			display: block;' + LineEnding +
    '			font-size: 1.25em;' + LineEnding +
    '			font-weight: bold;' + LineEnding +
    '		}' + LineEnding +
    '		#header > nav {' + LineEnding +
    '			-moz-flex: 1;' + LineEnding +
    '			-webkit-flex: 1;' + LineEnding +
    '			-ms-flex: 1;' + LineEnding +
    '			flex: 1;' + LineEnding +
    '			text-align: right;' + LineEnding +
    '		}' + LineEnding +
    '		#header > nav > ul {' + LineEnding +
    '			margin: 0;' + LineEnding +
    '			padding: 0;' + LineEnding +
    '		}' + LineEnding +
    '		#header > nav > ul > li {' + LineEnding +
    '			display: inline-block;' + LineEnding +
    '			margin-left: 1.75em;' + LineEnding +
    '			padding: 0;' + LineEnding +
    '			vertical-align: middle;' + LineEnding +
    '		}' + LineEnding +
    '		#header > nav > ul > li:first-child {' + LineEnding +
    '			margin-left: 0;' + LineEnding +
    '		}' + LineEnding +
    '		#header > nav > ul > li a {' + LineEnding +
    '			border: 0;' + LineEnding +
    '			color: rgba(255, 255, 255, 0.35);' + LineEnding +
    '			display: inline-block;' + LineEnding +
    '			font-size: 0.6em;' + LineEnding +
    '			font-weight: bold;' + LineEnding +
    '			letter-spacing: 0.25em;' + LineEnding +
    '			text-transform: uppercase;' + LineEnding +
    '		}' + LineEnding +
    '		#header > nav > ul > li a:hover {' + LineEnding +
    '			color: rgba(255, 255, 255, 0.55);' + LineEnding +
    '		}' + LineEnding +
    '		#header > nav > ul > li a.active {' + LineEnding +
    '			color: #ffffff;' + LineEnding +
    '		}' + LineEnding +
    '			@media screen and (max-width: 736px) {' + LineEnding +
    '				#header {' + LineEnding +
    '					padding: 1em 2em;' + LineEnding +
    '				}' + LineEnding +
    '			}' + LineEnding +
    '			@media screen and (max-width: 480px) {' + LineEnding +
    '				#header {' + LineEnding +
    '					display: block;' + LineEnding +
    '					padding: 0 2em;' + LineEnding +
    '					text-align: left;' + LineEnding +
    '				}' + LineEnding +
    '				#header .title {' + LineEnding +
    '					font-size: 1.25em;' + LineEnding +
    '					padding: 1em 0;' + LineEnding +
    '				}' + LineEnding +
    '				#header > nav {' + LineEnding +
    '					border-top: solid 1px rgba(255, 255, 255, 0.15);' + LineEnding +
    '					text-align: inherit;' + LineEnding +
    '				}' + LineEnding +
    '				#header > nav > ul > li {' + LineEnding +
    '					margin-left: 1.5em;' + LineEnding +
    '				}' + LineEnding +
    '				#header > nav > ul > li a {' + LineEnding +
    '					height: 6em;' + LineEnding +
    '					line-height: 6em;' + LineEnding +
    '				}' + LineEnding +
    '			}' + LineEnding +
    '			#header + #wrapper > .wrapper > .inner {' + LineEnding +
    '				margin: 0 auto;' + LineEnding +
    '			}' + LineEnding +
    '		</style>' + LineEnding +
    '	</head>' + LineEnding +
    '	<body class="is-preload">' + LineEnding +
    '			<header id="header">' + LineEnding +
    '				<span class="title">Fano Application Error</span>' + LineEnding +
    '				<nav>' + LineEnding +
    '					<ul><li><a href="https://fanoframework.github.io">Documentation</a></li></ul>' + LineEnding +
    '				</nav>' + LineEnding +
    '			</header>' + LineEnding +
    '			<div id="wrapper">';
