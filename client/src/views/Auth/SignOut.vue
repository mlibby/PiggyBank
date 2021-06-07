<template>
    <main>
        <spinner-div ref="spinner" v-bind:onLoad="signUserOut">
            <h1>Signed Out</h1>
            <p>You have been signed out.</p>
            <p>
                To sign in again, visit
                <router-link to="/sign-in">the sign in page</router-link>
            </p>
        </spinner-div>
    </main>
</template>

<script>
import $axios from "@/axios.js";
import SpinnerDiv from "@/components/SpinnerDiv.vue";

export default {
    components: { SpinnerDiv },
    name: "SignOut",
    title: "Sign Out",
    mounted() {
        this.$refs.spinner.load();
    },
    methods: {
        signUserOut(next) {
            $axios.post("/api/auth/sign-out").then(() => {
                this.$root.signedIn = false;
                next();
            });
        },
    },
};
</script>
