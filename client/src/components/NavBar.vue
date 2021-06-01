<template>
    <nav role="navigation">
        <section class="icon">
            <router-link to="/">
                <span class="icon icon-pig"></span>
                <span class="sr-only">Home</span>
            </router-link>
        </section>
        <section>
            <button class="label">Accounts</button>
            <div class="menu">
                <router-link to="/accounts"> Accounts </router-link>
            </div>
        </section>
        <section>
            <button class="label">Tools</button>
            <div class="menu">
                <router-link to="/tools/amortization"> Amortization </router-link>
            </div>
        </section>
    </nav>
</template>

<script>
export default {
    name: "NavBar",
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
    background-color: var(--nav-bg);
    border: 0;
    color: var(--primary-color);
    font-size: 1.25rem;
    font-weight: bold;
    text-decoration: none;
    vertical-align: middle;
    -moz-box-shadow: none;
    -webkit-box-shadow: none;
    box-shadow: none;
}

nav a:focus,
nav .label:focus {
    color: var(--bg-color);
    background-color: var(--nav-bg);
}

nav .icon {
    vertical-align: middle;
    background-color: var(--nav-bg);
}

nav .label {
    background-color: var(--nav-bg);
}

nav .label:focus,
nav .label:hover {
    -moz-box-shadow: none;
    -webkit-box-shadow: none;
    background-color: var(--nav-bg);
    box-shadow: none;
    color: var(--bg-color);
    cursor: pointer;
}

nav section {
    display: inline-block;
    flex-direction: column;
    transition-duration: 0.5s;
}

nav section.icon {
    padding-right: 1rem;
}

nav section:last-child {
    margin-left: auto;
}

nav section .menu {
    background-color: var(--nav-bg);
    flex-direction: column;
    transition: all 0.5s ease;
    margin: 0.25rem 0rem;
    opacity: 0;
    padding: 0.5rem;
    position: absolute;
    z-index: -1;
}

nav section:focus-within .menu {
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
