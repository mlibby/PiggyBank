<template>
    <form v-on:submit.prevent="saveAccount">
        <label for="account-id">Account ID</label>
        <input id="account-id" type="text" v-bind:value="account.id" disabled />
        <label for="account-name">Account Name</label>
        <input id="account-name" type="text" v-model="account.name" />
        <label for="account-type">Account Type</label>
        <select id="account-type" v-model="account.account_type">
            <option v-for="accountType in accountTypes">
                {{ accountType }}
            </option>
        </select>
        <label class="checkbox">
            <input
                id="account-is-placeholder"
                type="checkbox"
                v-model="account.is_placeholder"
            />
            Placeholder?
        </label>
        <label for="account-commodity">Commodity</label>
        <select id="account-commodity" v-model="account.commodity_id">
            <option
                v-for="commodity in commodities"
                v-bind:value="account.commodity_id"
                :key="commodity.id"
            >
                {{ commodity.name }}
            </option>
        </select>
        <label for="account-parent">Parent Account</label>
        <select id="account-parent" v-model="account.parent_id">
            <option
                v-for="account in accounts"
                v-bind:value="account.id"
                :key="account.id"
            >
                {{ account.full_name }}
            </option>
        </select>
        <input type="submit" class="btn primary" value="Save Account" />
        <router-link to="/accounts">Cancel</router-link>
    </form>
</template>

<script>
import axios from "axios";

export default {
    name: "AccountForm",
    props: ["account", "accounts", "account-types", "commodities"],
    methods: {
        saveAccount() {
            const data = {
                name: this.account.name,
                account_type: this.account.account_type,
                is_placeholder: this.account.is_placeholder,
                commodity_id: this.account.commodity_id,
                parent_id: this.account.parent_id,
            };
            axios.post("/api/account/" + this.account.id, data).then(() => {
                window.alert("account saved");
            });
        },
    },
};
</script>

<style scoped></style>
