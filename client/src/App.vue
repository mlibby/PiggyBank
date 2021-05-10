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
    --primary-accent: #03e4a0;
    --secondary-color: #666666;
    --danger-color: red;
    --nav-bg: black;
    --bg-color: white;
    --bg-shaded: #e8e8e8;
}

@font-face {
    font-family: "Fira Mono";
    src: local("Fira Mono"), url(./assets/fonts/FiraMono-Medium.ttf) format("truetype");
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
textarea {
    font-family: "Fira Mono" !important;
    font-size: 1rem;
    font-weight: normal;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    box-sizing: border-box;
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
}

body,
header {
    margin: 0;
}

form label {
    margin: 0 0 3px 0;
    padding: 0px;
    display: block;
    font-weight: bold;
}

form input[type=text],
form input[type=checkbox],
form input[type=date],
form input[type=datetime],
form input[type=number],
form input[type=search],
form input[type=time],
form input[type=url],
form input[type=email],
form textarea,
form select {
    display: block;
    border: 1px solid #BEBEBE;
    padding: 7px;
    margin: 0.25rem 0;
    outline: none;
    max-width: 35rem;
    width: 100%;
}

form input[type=checkbox] {
    width: 2rem;
}

form input[type=number] {
    -moz-appearance: textfield;
}

form input[type=number]::-webkit-inner-spin-button,
form input[type=number]::-webkit-outer-spin-button {
    -webkit-appearance: none;
    margin: 0;
}

form input[type=text]:focus,
form input[type=checkbox]:focus,
form input[type=date]:focus,
form input[type=datetime]:focus,
form input[type=number]:focus,
form input[type=search]:focus,
form input[type=time]:focus,
form input[type=url]:focus,
form input[type=email]:focus,
form textarea:focus,
form select:focus {
  -moz-box-shadow: 0 0 8px #88D5E9;
  -webkit-box-shadow: 0 0 8px #88D5E9;
  box-shadow: 0 0 8px #88D5E9;
  border: 1px solid #88D5E9;
}

form input[type=text]:focus,
form input[type=date]:focus,
form input[type=datetime]:focus,
form input[type=number]:focus,
form input[type=search]:focus,
form input[type=time]:focus,
form input[type=url]:focus,
form input[type=email]:focus,
form textarea:focus,
form select:focus {
  -moz-box-shadow: 0 0 8px #88D5E9;
  -webkit-box-shadow: 0 0 8px #88D5E9;
  box-shadow: 0 0 8px #88D5E9;
  border: 1px solid #88D5E9;
}

form fieldset {
  display: flex;
  flex-wrap: wrap;
  border: 1px dashed grey;
  margin-bottom: 0.5rem;
}

form fieldset .btn {
  margin-top: 2rem;
  margin-left: auto;
}

form fieldset label {
  margin-top: 0.66rem;
  margin-right: 2rem;
  min-width: 17%;
}

form fieldset input,
form fieldset select {
  height: 2.25rem;
}

form fieldset legend {
  font-weight: bold;
  font-size: 1.25rem;
  margin-left: -0.33rem;
  padding: 0 1rem;
}

input[type=submit]:hover,
input[type=button]:hover {
  background: #4691A4;
  box-shadow: none;
  -moz-box-shadow: none;
  -webkit-box-shadow: none;
}

.required {
  color: red;
}

h1,
h2,
h3,
h4,
h5,
h6 {
    margin: 0.25rem 0 0.5rem 0;
}

main {
    margin: 0;
    padding: 0.5rem;
}

.sr-only {
  position: absolute;
  left: -10000px;
  top: auto;
  width: 1px;
  height: 1px;
  overflow: hidden;
}
</style>
