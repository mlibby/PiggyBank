<template>
    <main>
        <h1>Edit Account</h1>
        <spinner-div ref="accountFormDiv" :onLoad="fetchAccount">
            <account-form v-bind:account="account"></account-form>
        </spinner-div>
    </main>
</template>

<script>
import axios from "axios";
import AccountForm from "@/components/account/form.vue";
import SpinnerDiv from "../../components/SpinnerDiv.vue";

export default {
    name: "AccountEdit",
    title: "Edit Account",
    components: { AccountForm, SpinnerDiv },
    data() {
        return {
            loading: true,
            account: null,
            error: null,
        };
    },
    mounted() {
        this.$refs.accountFormDiv.load();
    },
    methods: {
        fetchAccount(next, error) {
            axios
                .get("/api/account/" + this.$route.params.id)
                .then((response) => {
                    this.account = response.data;
                    next();
                })
                .catch((e) => {
                    error(e);
                });
        },
    },
};
</script>
