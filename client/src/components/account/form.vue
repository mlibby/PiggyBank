<template>
    <form v-on:submit.prevent="onSubmit">
        <label for="account-id">Account ID</label>
        <input id="account-id" type="text" v-bind:value="account.id" disabled />
        <label for="account-name">Account Name</label>
        <input
            id="account-name"
            type="text"
            v-model="account.name"
            v-bind:disabled="readonly"
        />
        <label for="account-type">Account Type</label>
        <select
            id="account-type"
            v-model="account.account_type"
            v-bind:disabled="readonly"
        >
            <option v-for="accountType in accountTypes">
                {{ accountType }}
            </option>
        </select>
        <label class="checkbox">
            <input
                id="account-is-placeholder"
                type="checkbox"
                v-model="account.is_placeholder"
                v-bind:disabled="readonly"
            />
            Placeholder?
        </label>
        <label for="account-commodity">Commodity</label>
        <select
            id="account-commodity"
            v-model="account.commodity_id"
            v-bind:disabled="readonly"
        >
            <option
                v-for="commodity in commodities"
                v-bind:value="account.commodity_id"
                :key="commodity.id"
            >
                {{ commodity.name }}
            </option>
        </select>
        <label for="account-parent">Parent Account</label>
        <select
            id="account-parent"
            v-model="account.parent_id"
            v-bind:disabled="readonly"
        >
            <option
                v-for="account in accounts"
                v-bind:value="account.id"
                :key="account.id"
            >
                {{ account.full_name }}
            </option>
        </select>
        <div v-if="readonly">
            <input
                v-if="account.parent_id"
                type="submit"
                class="btn primary"
                value="Edit Account"
            />
            <router-link to="/accounts">Go to Accounts</router-link>
        </div>
        <div v-else>
            <spinner-button :onClick="onSubmit"> Save Account </spinner-button>
            <a @click="$router.go(-1)">Cancel</a>
        </div>
    </form>
</template>

<script>
import SpinnerButton from "../SpinnerButton.vue";
export default {
    components: { SpinnerButton },
    name: "AccountForm",
    props: {
        account: { type: Object },
        accounts: { type: Array },
        accountTypes: { type: Array },
        commodities: { type: Array },
        onSubmit: { type: Function },
        readonly: { type: Boolean, default: false },
    },
};
</script>

<style scoped></style>
