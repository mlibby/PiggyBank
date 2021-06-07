<template>
    <nav role="navigation">
        <section class="icon">
            <router-link to="/">
                <span class="icon icon-pig"></span>
                <span class="sr-only">Home</span>
            </router-link>
        </section>
        <section>
            <button tabindex="-1" class="label">Accounts</button>
            <div class="menu">
                <router-link to="/accounts"> Chart of Accounts </router-link>
            </div>
        </section>
        <section>
            <button tabindex="-1" class="label">Tools</button>
            <div class="menu">
                <router-link to="/tools/amortization"> Amortization </router-link>
            </div>
        </section>
        <section class="right">
            <router-link v-if="signedIn" to="/sign-out">Sign Out</router-link>
            <router-link v-else to="/sign-in">Sign In</router-link>
        </section>
    </nav>
</template>

<script>
export default {
    name: "NavBar",
    props: ["signedIn"],
};
</script>

<style>
nav {
    line-height: 0.75rem;
    margin: 0;
    padding: 1rem;
    color: var(--bg-primary);
    background-color: var(--primary-color);
}

nav a,
nav .label {
    border: 0;
    font-size: 1.25rem;
    font-weight: bold;
    text-decoration: none;
    vertical-align: middle;
    -moz-box-shadow: none;
    -webkit-box-shadow: none;
    box-shadow: none;
}

nav .icon {
    vertical-align: middle;
    font-size: 1.8em;
    background-color: var(--primary-color);
    color: var(--bg-color);
}

nav .label:focus,
nav .label:focus-visible,
nav .label:hover {
    -moz-box-shadow: none;
    -webkit-box-shadow: none;
    box-shadow: none;
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

nav section.icon a {
    background-color: var(--primary-color);
}

nav section:last-child {
    margin-left: auto;
}

nav section .menu {
    background-color: var(--primary-color);
    color: var(--bg-primary);
    flex-direction: column;
    margin: 0.25rem 0rem;
    opacity: 0;
    padding: 0.5rem 0.5rem 0.25rem 0.5rem;
    position: absolute;
    transition: all 0.5s ease;
    z-index: -1;
    -moz-box-shadow: 0 0 8px var(--border);
    -webkit-box-shadow: 0 0 8px var(--border);
    box-shadow: 0 0 8px var(--border);
}

nav section:focus-within .menu {
    visibility: visible;
    opacity: 1;
    display: block;
    z-index: 1;
}

nav section .menu a {
    background-color: var(--primary-color);
    color: var(--bg-color);
    display: block;
    margin-bottom: 0.5rem;
    line-height: 1.5rem;
}

nav section.right {
    float: right;
    line-height: 2.33rem;
}

nav section.right a {
    background-color: var(--primary-color);
    color: var(--bg-color);
}
</style>
