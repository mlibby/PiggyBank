<template>
    <form>
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
    </form>
</template>

<script>
export default {
    name: "AccountForm",
    props: ["account", "accounts", "account-types"],
};
</script>

<style scoped></style>
