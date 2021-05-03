<template>
  <nav role='navigation'>
    <router-link to="/">Home</router-link> |
    <router-link to="/about">About</router-link>
  </nav>
</template>

<script>
export default {
  name: 'NavBar',
};
</script>

<style>
  nav { padding: 1px; }
</style>
