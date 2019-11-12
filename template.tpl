___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Sampling",
  "description": "Variables for sampling a percentage of the traffic. Returns true if the trigger should fire, false otherwise.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "sampleFreq",
    "displayName": "Sampling Frequency (percentage)",
    "simpleValueType": true,
    "defaultValue": 50,
    "valueValidators": [
      {
        "type": "PERCENTAGE"
      }
    ],
    "help": "Frequency of \"Test\" outcomes as an integer percentage (0-100)"
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

//Runs everytime variable is used, if needed to associate with session consider storing the result somewhere (eg cookie)

const log = require('logToConsole');
const generateRandom = require('generateRandom');

let randomNum = generateRandom(1,100);

if(randomNum <= data.sampleFreq) {
  return true;
}

else return false;


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Test 0
  code: |-
    // Call runCode to run the template's code.
    let variableResult = runCode({sampleFreq:0});

    // Verify that the variable returns a result.
    assertThat(variableResult).isNotEqualTo(undefined);

    //This should always be false if Test Frequency is 0%
    assertThat(variableResult).isFalse();
- name: Test 100
  code: |-
    // Call runCode to run the template's code.
    let variableResult = runCode({sampleFreq:100});

    // Verify that the variable returns a result.
    assertThat(variableResult).isNotEqualTo(undefined);

    //This should always be true if Test Frequency is 100%
    assertThat(variableResult).isTrue();
- name: Test 50 - Mock RandomNum
  code: |-
    //mock generateRandom to always return 50
    mock('generateRandom', ()=> {return 50;} );

    //testFreq = generateRandom, this should return true
    let variableResult = runCode({sampleFreq:50});
    // Verify that the variable returns a result.
    assertThat(variableResult).isNotEqualTo(undefined);
    //This should always be true if Test Frequency is 100%
    assertThat(variableResult).isTrue();

    //testFreq < generateRandom, this should return false
    variableResult = runCode({sampleFreq:49});
    // Verify that the variable returns a result.
    assertThat(variableResult).isNotEqualTo(undefined);
    //This should always be true if Test Frequency is 100%
    assertThat(variableResult).isFalse();

    //testFreq > generateRandom, this should return true
    variableResult = runCode({sampleFreq:51});
    // Verify that the variable returns a result.
    assertThat(variableResult).isNotEqualTo(undefined);
    //This should always be true if Test Frequency is 100%
    assertThat(variableResult).isTrue();
- name: Test 50 x10000
  code: |+
    const freq = 50;
    const iterations = 10000;
    let numTrue = 0;
    let numFalse = 0;


    //Run this code 10,000 times and see if the true frequency is within 1% of what we expect
    let variableResult;

    for(let i=0; i<iterations; i++){
      variableResult = runCode({sampleFreq:freq});
      if (variableResult){
        numTrue++;
      }
      else{
        numFalse++;
      }
      assertThat(variableResult).isNotEqualTo(undefined);
    }
    let observedFreq = numTrue / (numTrue + numFalse);
    let freqDelta = Math.abs(observedFreq * 100 - freq);

    log('numTrue: ', numTrue);
    log('numFalse: ', numFalse);
    log('observedFreq: ', observedFreq);
    log('freqDelta: ', freqDelta);

    assertThat(freqDelta < 1).isTrue();

setup: |-
  const log = require('logToConsole');
  const Math = require('Math');


___NOTES___

Created on 11/12/2019, 8:59:12 AM


