<template>
  <form>
    <label for="account-id">Account ID</label>
    <input id="account-id" type="text" v-bind="account.id" disabled />
  </form>
</template>

<script>
export default {
    name: "AccountForm",
    props: ["account"],
};
</script>

<style scoped>
</style>
