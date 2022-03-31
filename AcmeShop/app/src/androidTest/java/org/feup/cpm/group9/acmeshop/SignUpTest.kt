package org.feup.cpm.group9.acmeshop


import androidx.test.espresso.Espresso.onView
import androidx.test.espresso.action.ViewActions.*
import androidx.test.espresso.assertion.ViewAssertions.matches
import androidx.test.espresso.matcher.ViewMatchers.withId
import androidx.test.espresso.matcher.ViewMatchers.withText
import androidx.test.ext.junit.rules.ActivityScenarioRule
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.filters.LargeTest
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith


@RunWith(AndroidJUnit4::class)
@LargeTest
class SignUpTest {
    @get:Rule
    var rule: ActivityScenarioRule<SignUpActivity> = ActivityScenarioRule(SignUpActivity::class.java)

    @Test
    fun testForm() {
        onView(withId(R.id.user_name_edt))
            .perform(typeText("Goncalo"))
        onView(withId(R.id.user_name_edt))
            .check(matches(withText("Goncalo")))

        onView(withId(R.id.user_address_edt))
            .perform(typeText("Rua 1"))
        onView(withId(R.id.user_address_edt))
            .check(matches(withText("Rua 1")))

        onView(withId(R.id.user_email_edt))
            .perform(typeText("email@example.com"))
        onView(withId(R.id.user_email_edt))
            .check(matches(withText("email@example.com")))

        onView(withId(R.id.user_vat_edt))
            .perform(typeText("123123123"))
        onView(withId(R.id.user_vat_edt))
            .check(matches(withText("123123123")))

        onView(withId(R.id.user_password_edt))
            .perform(typeText("123"))
        onView(withId(R.id.user_password_edt))
            .check(matches(withText("123")))

        onView(withId(R.id.user_confirm_password_edt))
            .perform(typeText("123"))
        onView(withId(R.id.user_confirm_password_edt))
            .check(matches(withText("123")))

        onView(withId(R.id.user_card_number_edt))
            .perform(typeText("123123123"))
        onView(withId(R.id.user_card_number_edt))
            .check(matches(withText("123123123")))

        onView(withId(R.id.user_card_type_edt))
            .perform(typeText("visa"))
        onView(withId(R.id.user_card_type_edt))
            .check(matches(withText("visa")))

        onView(withId(R.id.user_card_validity_edt))
            .perform(typeText("10/22"), closeSoftKeyboard())
        onView(withId(R.id.user_card_validity_edt))
            .check(matches(withText("10/22")))

        onView(withId(R.id.signup_submin_btn))
            .perform(click())
    }
}