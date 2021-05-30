<template>
    <form>
        <label for="account-id">Account ID</label>
        <input id="account-id" type="text" v-bind:value="account.id" disabled />
        <label for="account-name">Account Name</label>
        <input id="account-name" type="text" v-model="account.name" />
        <label for="account-type">Account Type</label>
        <select id="account-type" v-model="account.account_type">
            <option>ASSET</option>
            <option>EQUITY</option>
            <option>EXPENSE</option>
            <option>INCOME</option>
            <option>LIABILITY</option>
            <option>MORTGAGE</option>
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
          <option value="1">Equity</option>
          <option value="2">Liabilities</option>
        </select>
    </form>
</template>

<script>
export default {
    name: "AccountForm",
    props: ["account"],
};
</script>

<style scoped></style>
