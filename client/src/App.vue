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
