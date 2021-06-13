<template>
    <main>
        <h1>Please Sign In</h1>
        <p>You need to be signed in to view that page or perform that action</p>
        <form v-on:submit.prevent>
            <label for="username">User name</label>
            <input id="username" v-model="username" type="text" maxlength="32" />
            <label for="password">Password</label>
            <input id="password" v-model="password" type="password" maxlength="1024" />
            <spinner-button :onClick="submitForm">Sign In</spinner-button>
        </form>
        <div v-if="errorMessage" class="error">
            <span class="icon icon-warning">
                <span class="sr-only"> Error: </span>
            </span>
            {{ errorMessage }}
        </div>
    </main>
</template>

<script>
  import axios from "axios";
//import $axios from "@/axios.js";
import SpinnerButton from "@/components/SpinnerButton.vue";

export default {
    components: { SpinnerButton },
    name: "SignIn",
    title: "Sign In",
    data() {
        return {
            errorMessage: null,
            password: null,
            username: null,
        };
    },
    methods: {
        submitForm(next) {
            const data = {
                username: this.username,
                password: this.password,
            };

            axios
                .post("/api/auth/sign-in", data)
                .then(() => {
                    let redirect = "/";
                    if (this.$route.query.then) {
                        redirect = this.$route.query.then;
                    }
                    this.$root.signedIn = true;
                    this.$router.push(redirect);
                })
                .catch((error) => {
                    this.errorMessage = error.message;
                    next();
                });
        },
    },
};
</script>

<style scoped>
form {
    margin-bottom: 1.33rem;
}
</style>
