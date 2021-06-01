<template>
    <body id="app">
        <IcoMoon> </IcoMoon>
        <NavBar> </NavBar>
        <flash-message></flash-message>
        <router-view />
    </body>
</template>

<script>
import IcoMoon from "@/components/IcoMoon.vue";
import NavBar from "@/components/NavBar.vue";

export default {
    name: "App",
    title: "PiggyBank",
    components: {
        IcoMoon,
        NavBar,
    },
};
</script>

<style>
:root {
    --primary-text: #001912;
    --primary-color: #05a172;
    --primary-accent: #34bd94;
    --secondary-color: #093566;
    --secondary-accent: #3f7abc;
    --danger-color: #9c3802;
    --danger-accent: #ff8746;
    --warn-color: #9c5f02;
    --warn-accent: #ffb646;
    --nav-bg: #001912;
    --border: #001912;
    --bg-color: linen;
    --bg-accent: ivory;
    --bg-primary: #75e7c5;
    --bg-secondary: #7eb0e7;
    --bg-danger: #ffad81;
    --bg-warn: #ffcd81;
}

@font-face {
    font-family: "JetBrainsMono";
    src: url(./assets/fonts/JetBrainsMono-Regular.ttf) format("truetype");
}

body,
nav {
    min-width: 310px;
}

a,
body,
input,
button,
select,
optgroup,
option,
textarea {
    font-family: "JetBrainsMono", ui-monospace, "Cascadia Mono", "Segoe UI Mono",
        "Ubuntu Mono", "Roboto Mono", Menlo, Monaco, Consolas, monospace;
    font-size: 1rem;
    font-weight: normal;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    box-sizing: border-box;
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
    color: var(--primary-text);
    background-color: var(--bg-color);
}

a {
    display: inline-block;
    text-decoration: underline;
    cursor: pointer;
}

body,
header {
    margin: 0;
}

.column {
    display: flex;
    flex-direction: column;
    flex: 1;
    margin-right: 2rem;
}

.column-1-4 {
    flex: 0.25;
}

.columns {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
}

div.error {
    background-color: var(--bg-danger);
    border: 1px solid var(--danger-color);
    color: var(--danger-color);
    font-size: 1.25rem;
    padding: 1rem;
}

.flash__close-button {
    border-radius: 0 0.5rem 0 0;
    float: right;
    margin: -1rem;
    padding: 0.25rem;
    font-size: 2rem;
    border: 0;
    color: var(--bg-color);
    background-color: var(--primary-text);
    line-height: 0;
}

.flash__message {
    background-color: var(--bg-accent);
    border-radius: 0.5rem;
    border: 1px solid var(--border);
    display: block;
    margin: 1.33rem 1rem 0 1rem;
    padding: 1rem;
    height: 2rem;
}

.flash__message::before {
    display: block;
    float: left;
    font-family: "icomoon";
    font-size: 2rem;
}

.flash__message.deleted::before {
    content: "\e632";
    color: var(--primary-color);
}

.flash__message.saved::before {
    content: "\e61a";
    color: var(--primary-color);
}

.flash__message-content {
    float: left;
    margin-left: 1rem;
    width: 75%;
}

h1 {
    margin: 0 0 0.5rem;
}

h2,
h3,
h4,
h5,
h6 {
    margin: 1rem 0 0.5rem 0;
}

input[type="text"],
input[type="checkbox"],
input[type="date"],
input[type="datetime"],
input[type="number"],
input[type="search"],
input[type="time"],
input[type="url"],
input[type="email"],
textarea,
select {
    background-color: var(--bg-accent);
    border: 1px solid var(--border);
    display: block;
    margin: 0.25rem 0 1rem 0;
    outline: none;
    padding: 7px;
    width: 15rem;
}

input[type="checkbox"] {
    width: 2rem;
}

input[type="number"] {
    -moz-appearance: textfield;
}

input[type="number"]::-webkit-inner-spin-button,
input[type="number"]::-webkit-outer-spin-button {
    -webkit-appearance: none;
    margin: 0;
}

input[type="text"]:focus,
input[type="date"]:focus,
input[type="datetime"]:focus,
input[type="number"]:focus,
input[type="search"]:focus,
input[type="time"]:focus,
input[type="url"]:focus,
input[type="email"]:focus,
textarea:focus,
select:focus {
    -moz-box-shadow: 0 0 8px var(--bg-secondary);
    -webkit-box-shadow: 0 0 8px var(--bg-secondary);
    box-shadow: 0 0 8px var(--bg-secondary);
}

a.btn,
button,
input[type="submit"],
input[type="button"] {
    background-color: var(--primary-color);
    border-radius: 0.5rem;
    border-width: 0;
    color: var(--bg-color);
    display: inline-block;
    font-weight: bold;
    height: 2.25rem;
    line-height: 1rem;
    margin: 0 0.66rem 0 0;
    padding: 0.66rem 0.66rem;
    text-align: center;
    text-decoration: none;
    vertical-align: middle;
}

a.btn.danger,
button.danger,
input[type="submit"].danger,
input[type="button"].danger {
    background-color: var(--danger-color);
}

a.btn.secondary,
button.secondary,
input[type="submit"].secondary,
input[type="button"].secondary {
    background-color: var(--secondary-color);
}

a.btn:focus,
a.btn:hover,
button:hover,
input[type="submit"]:hover,
input[type="button"]:hover {
    -moz-box-shadow: 2px 2px 8px var(--border);
    -webkit-box-shadow: 2px 2px 8px var(--border);
    box-shadow: 2px 2px 8px var(--border);
}

input[type="text"][disabled],
input[type="date"][disabled],
input[type="datetime"][disabled],
input[type="number"][disabled],
input[type="search"][disabled],
input[type="time"][disabled],
input[type="url"][disabled],
input[type="email"][disabled],
textarea[disabled],
select[disabled] {
    border: 0;
    background-color: var(--bg-primary);
}

label {
    margin: 0 0 3px 0;
    padding: 0px;
    display: block;
    font-weight: bold;
}

label.checkbox {
    display: inline-block;
    margin-left: 0;
    padding-left: 0;
}

label.checkbox input {
    margin: 0.5rem -0.5rem 1.5rem;
    display: inline-block;
    height: 1rem;
}

main {
    margin: 0;
    padding: 1rem;
}

.required {
    color: var(--danger-color);
}

.sr-only {
    position: absolute;
    left: -10000px;
    top: auto;
    width: 1px;
    height: 1px;
    overflow: hidden;
}

table {
    border-collapse: collapse;
    border-spacing: 0;
    display: inline-block;
    text-align: right;
}

td {
    padding: 0.33rem 1.1rem 0.16rem 1rem;
    border-bottom: 1px solid var(--primary-accent);
}

td input[type="text"],
td input[type="checkbox"],
td input[type="date"],
td input[type="datetime"],
td input[type="number"],
td input[type="search"],
td input[type="time"],
td input[type="url"],
td input[type="email"],
td textarea,
td select {
    margin: 0;
    padding-bottom: 0;
    padding-top: 0;
    text-align: right;
}

th {
    padding: 0.33rem 1rem 0.16rem;
    border-bottom: 1px solid var(--primary-color);
    min-width: 5rem;
}

th:first-of-type {
    min-width: 0;
}

tr:nth-child(even) {
    background-color: var(--bg-primary);
}
</style>
