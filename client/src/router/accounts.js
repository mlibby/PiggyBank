import AccountIndex from "../views/account/index.vue";
import Account from "../views/account.vue";
import AccountView from "../views/account/view.vue";
import AccountNew from "../views/account/new.vue";
import AccountEdit from "../views/account/edit.vue";
import AccountDelete from "../views/account/delete.vue"

const accountRoutes = [
    {
        path: "/accounts",
        component: AccountIndex,
    },
    {
        path: "/account/view/:id",
        component: AccountView,
    },
    {
        name: "new_account",
        path: "/account/new/:id",
        component: AccountNew,
    },
    {
        name: "edit_account",
        path: "/account/edit/:id",
        component: AccountEdit,
    },
    {
        name: "delete_account",
        path: "/account/delete/:id",
        component: AccountDelete,
    },
]
        
export default accountRoutes;
