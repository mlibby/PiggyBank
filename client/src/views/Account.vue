<template>
    <main>
        <router-view
            ref="accountView"
            v-bind:account="account"
            v-bind:accounts="accounts"
            v-bind:account-types="accountTypes"
            v-bind:commodities="commodities"
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

export default {
    name: "Account",
    data() {
        return {
            account: null,
            accounts: [],
            accountTypes: [],
            commodities: [],
        };
    },
    methods: {
        async fetchAccount(next, error) {
            const [
                accountsResponse,
                accountTypesResponse,
                accountReponse,
                commoditiesResponse,
            ] = await Promise.all([
                this.$root.axios.get("/api/account/"),
                this.$root.axios.get("/api/account/types"),
                this.$root.axios.get("/api/account/" + this.$route.params.id),
                this.$root.axios.get("/api/commodity/"),
            ]).catch((e) => {
                error(e);
            });

            this.accountTypes = accountTypesResponse.data;
            this.commodities = commoditiesResponse.data;

            if (this.$route.path.match("new$")) {
                this.account = {
                    id: null,
                    parent_id: this.$route.params["id"],
                    is_placeholder: false,
                    // TODO: add a "default" indicator to Commodity
                    commodity_id: this.commodities[0].id,
                    account_type: null,
                };
            } else {
                this.account = accountReponse.data;
            }

            this.accounts = accountsResponse.data;
            this.accounts.sort((first, second) => {
                return first.full_name.localeCompare(second.full_name);
            });
            this.accounts = this.accounts.filter(
                (account) => account.id != this.account.id
            );

            next();
        },
    },
};
</script>
