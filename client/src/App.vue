<template>
<body id='app'>
  <IcoMoon>
  </IcoMoon>
  <NavBar>
  </NavBar>
  <router-view/>
</body>
</template>

<script>
import IcoMoon from '@/components/IcoMoon.vue';
import NavBar from '@/components/NavBar.vue';

export default {
  name: 'App',
  title: 'PiggyBank',
  components: {
    IcoMoon,
    NavBar,
  },
};
</script>

<style>
:root {
    --primary-color: #05a172;
    --primary-accent: #55f1b2;
    --secondary-color: #057132;
    --danger-color: red;
    --nav-bg: black;
    --border: black;
    --bg-color: linen;
    --bg-shaded: bisque;
    --bg-secondary: #55f1b2;
    /* --bg-secondary: mediumspringgreen; */
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
    font-family: 'JetBrainsMono',
                 ui-monospace,
                 'Cascadia Mono',
                 'Segoe UI Mono',
                 'Ubuntu Mono',
                 'Roboto Mono',
                 Menlo, Monaco, Consolas,
                 monospace;
    font-size: 1rem;
    font-weight: normal;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    box-sizing: border-box;
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
    color: var(--fg-color);
    background-color: var(--bg-color);
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

input[type=text],
input[type=checkbox],
input[type=date],
input[type=datetime],
input[type=number],
input[type=search],
input[type=time],
input[type=url],
input[type=email],
textarea,
select {
    display: block;
    border: 1px solid #BEBEBE;
    padding: 7px;
    margin: 0.25rem 0 1rem 0;
    outline: none;
    width: 15rem;
}

input[type=checkbox] {
    width: 2rem;
}

input[type=number] {
    -moz-appearance: textfield;
}

input[type=number]::-webkit-inner-spin-button,
input[type=number]::-webkit-outer-spin-button {
    -webkit-appearance: none;
    margin: 0;
}

input[type=text]:focus,
input[type=date]:focus,
input[type=datetime]:focus,
input[type=number]:focus,
input[type=search]:focus,
input[type=time]:focus,
input[type=url]:focus,
input[type=email]:focus,
textarea:focus,
select:focus {
    -moz-box-shadow: 0 0 8px var(--bg-secondary);
    -webkit-box-shadow: 0 0 8px var(--bg-secondary);
    box-shadow: 0 0 8px var(--bg-secondary);
    border: 1px solid var(--border);
}

button,
input[type=submit],
input[type=button] {
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

button:focus,
button:hover,
input[type=submit]:focus,
input[type=submit]:hover,
input[type=button]:focus,
input[type=button]:hover {
    background: var(--secondary-color);
    -moz-box-shadow: 0 0 8px var(--bg-secondary);
    -webkit-box-shadow: 0 0 8px var(--bg-secondary);
    box-shadow: 0 0 8px var(--bg-secondary);
}

label {
    margin: 0 0 3px 0;
    padding: 0px;
    display: block;
    font-weight: bold;
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

td input[type=text],
td input[type=checkbox],
td input[type=date],
td input[type=datetime],
td input[type=number],
td input[type=search],
td input[type=time],
td input[type=url],
td input[type=email],
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
    background-color: var(--bg-secondary);
}
</style>
