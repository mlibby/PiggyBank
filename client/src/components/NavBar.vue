<template>
<nav role='navigation'>
  <section>
    <router-link to='/'>
      <span class='icon icon-pig'></span>
      <span class='sr-only'>Home</span>
    </router-link>
  </section>
  <section>
    <span class="label">Tools</span>
    <div class="menu">
      <router-link to='/tools/amortization'>Amortization</router-link>
    </div>
  </section>
</nav>
</template>

<script>
export default {
  name: 'NavBar',
};
</script>

<style>
nav {
    line-height: 0.75rem;
    margin: 0;
    padding: 1rem;
    background-color: var(--nav-bg);
}

nav a,
nav .label {
    color: var(--primary-color);
    background-color: var(--nav-bg);
    font-size: 1.25rem;
    font-weight: bold;
    text-decoration: none;
    vertical-align: middle;
}

nav a:hover,
nav .label:hover {
    color: var(--bg-color);
    background-color: var(--nav-bg);
}

nav .icon {
    vertical-align: middle;
    background-color: var(--nav-bg);
}

nav .label {
    padding-top: 0.75rem;
    background-color: var(--nav-bg);
}

nav .label:hover {
  cursor: pointer;
}

nav section {
  padding-right: 1rem;
  display: inline-block;
  flex-direction: column;
  transition-duration: 0.5s;
}

nav section:last-child {
  margin-left: auto;
}

nav section .menu {
  background-color: var(--nav-bg);
  flex-direction: column;
  transition: all 0.5s ease;
  margin-left: -1rem;
  margin-top: 1.33rem;
  opacity: 0;
  padding: 1rem;
  position: absolute;
  z-index: -1;
}

nav section:focus-within .menu,
nav section:hover .menu,
nav section .menu:hover {
  visibility: visible;
  opacity: 1;
  display: block;
  z-index: 1;
}

nav section .menu a {
  display: block;
  margin-bottom: 0.5rem;
  line-height: 1.5rem;
}

nav .icon {
  font-size: 1.8em;
}
</style>
