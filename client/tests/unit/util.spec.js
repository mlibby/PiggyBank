import { formatCurrency } from "@/util.js";

describe("util.js", () => {
    it("formats numbers as currency", () => {
        expect(formatCurrency(1)).toBe("$1.00");
        expect(formatCurrency(1.2)).toBe("$1.20");
        expect(formatCurrency(1.23)).toBe("$1.23");
        expect(formatCurrency(1.2345)).toBe("$1.23");
    });
});
