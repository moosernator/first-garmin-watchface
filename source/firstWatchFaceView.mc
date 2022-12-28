import Toybox.Graphics;
import Toybox.Time;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;
using Toybox.ActivityMonitor as Mon;

using Toybox.Time.Gregorian as Date;

class firstWatchFaceView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get and show the current time
        setTimeDisplay();

        // Get and show the current data
        setDateDisplay();

        // Get and show the current battery
        setBatteryDisplay();

        // Get and show the current number of notifications
        setNotificationCountDisplay();

        // Get and show the current heart rate data
        setHeartRateDisplay();

        // Get and show the current step data
        setStepDisplay();

        // Get and show the current calorie data
        setCaloriesDisplay();

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    hidden function setTimeDisplay() {
        var clockTime = System.getClockTime();
        var hourString = Lang.format("$1$", [clockTime.hour]);
        var minuteString = Lang.format("$1$", [clockTime.min.format("%02d")]);
        var secondString = Lang.format("$1$", [clockTime.sec]);

        var hourView = View.findDrawableById("HourLabel") as Text;
        var minuteView = View.findDrawableById("MinuteLabel") as Text;
        var secondView = View.findDrawableById("SecondLabel") as Text;

        hourView.setText(hourString);
        minuteView.setText(minuteString);
        secondView.setText(secondString);
    }

    hidden function setBatteryDisplay() {
    	var battery = System.getSystemStats().battery;
        var batteryDisplay = View.findDrawableById("BatteryLabel") as Text;
        batteryDisplay.setText("Batt: " + battery.format("%d") + "%");
    }

    hidden function setDateDisplay() {
    	var now = Time.now();
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateString = Lang.format("$1$ $2$ $3$", [today.day_of_week, today.day, today.month]);
        var dateDisplay = View.findDrawableById("DateLabel") as Text;
        dateDisplay.setText(dateString);
    }

    hidden function setNotificationCountDisplay() {
    	var notificationAmount = System.getDeviceSettings().notificationCount;

        var formattedNotificationAmount = "";

        if(notificationAmount > 10)	{
            formattedNotificationAmount = "Notif 10+";
        }
        else {
            formattedNotificationAmount = "Notif " + notificationAmount.format("%d");
        }

        var notificationCountDisplay = View.findDrawableById("NotificationCountLabel") as Text;
        notificationCountDisplay.setText(formattedNotificationAmount);
    }

    hidden function setHeartRateDisplay() {
        var heartRate = "";
        if (Mon has :getHeartRateHistory) {
            heartRate = Activity.getActivityInfo().currentHeartRate;

            if(heartRate==null) {
                var HRH=Mon.getHeartRateHistory(1, true);
                var HRS=HRH.next();

                if(HRS!=null && HRS.heartRate!= Mon.INVALID_HR_SAMPLE){

                    heartRate = HRS.heartRate;
                }
            }

            if(heartRate!=null) {
                heartRate = "HR " + heartRate.toString();
            } else {
                heartRate = "HR --";
            }
        }

        var heartRateDisplay = View.findDrawableById("HeartRateLabel") as Text;
        heartRateDisplay.setText(heartRate);
    }

    hidden function setStepDisplay() {
    	var stepsData = Mon.getInfo().steps.toString();
        var steps = "";

        if (stepsData != null) {
            steps = "Steps\n" + stepsData;
        }

        var stepsDisplay = View.findDrawableById("StepsLabel") as Text;
        stepsDisplay.setText(steps);
    }

    hidden function setCaloriesDisplay() {
    	var caloriesData = Mon.getInfo().calories.toString();
        var calories = "";

        if (caloriesData != null) {
            calories = "Cals\n" + caloriesData;
        }

        var caloriesDisplay = View.findDrawableById("CaloriesLabel") as Text;
        caloriesDisplay.setText(calories);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
