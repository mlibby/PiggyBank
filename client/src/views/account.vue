<template>
    <main>
        <router-view
            ref="accountView"
            v-bind:account="account"
            v-bind:accounts="accounts"
            v-bind:account-types="accountTypes"
            v-bind:onLoad="fetchAccount"
        ></router-view>
    </main>
</template>

<script>
//
// This view hosts the view, new, edit, and delete nested views as
// <router-view>. This main view handles fetching account data from
// the API for both account details, and for populating drop-downs in
// the nested views. That way the nested views don't have to duplicate
// the API logic.
//
import axios from "axios";

export default {
    name: "Account",
    data() {
        return {
            account: null,
            accounts: [],
            accountTypes: [],
        };
    },
    mounted() {
        this.$refs.accountView.load();
    },
    methods: {
        async fetchAccount(next, error) {
            const [accountsResponse, accountTypesResponse, accountReponse] =
                await Promise.all([
                    axios.get("/api/account/"),
                    axios.get("/api/account/types"),
                    axios.get("/api/account/" + this.$route.params.id),
                ]).catch((e) => {
                    error(e);
                });

            this.account = accountReponse.data;
            this.accounts = accountsResponse.data;
            this.accounts.sort((first, second) => {
                return first.full_name.localeCompare(second.full_name);
            });
            const thisAccountIndex = this.accounts.findIndex((account) => {
                account.id == this.account.id;
            });
            this.accounts.splice(thisAccountIndex, 1);
            this.accountTypes = accountTypesResponse.data;

            next();
        },
    },
};
</script>
