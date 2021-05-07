<template>
<div id="app">
  <NavBar>
  </NavBar>
  <router-view/>
</div>
</template>

<script>
import NavBar from '@/components/NavBar.vue';

export default {
  name: 'App',
  components: {
    NavBar,
  },
};

</script>

<style>
@font-face {
  font-family: "Fira Mono";
  src: local("Fira Mono"), url(./assets/fonts/FiraMono-Medium.ttf) format("truetype");
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

#app {
  text-align: center;
  color: #2c3e50;
}

#nav {
  padding: 30px;
}

#nav a {
  font-weight: bold;
  color: #2c3e50;
}

#nav a.router-link-exact-active {
  color: #42b983;
}
</style>
