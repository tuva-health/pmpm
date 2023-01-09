# PMPM

## 🧰 What does this package do?

The Tuva Project's PMPM data mart makes it simple to calculate spend and utilization measures over any time period and over any population segment (e.g. patients diagnosed with type 2 diabetes).  The main output table from the data mart - called pmpm_builder - has one record per member per month and includes the spend for that member, broken out by medical and pharmacy (see Table 1 below).

![pmpm_builder](https://github.com/tuva-health/pmpm/blob/refactor-to-package/.github/pmpm_builder_sample.png?raw=true)

For example, you can use the following query to trend PMPM for the past 12 months

```sql
select
    year_month
,   sum(total_paid)/count(1)
from pmpm_builder
where year_month between '202201' and '202212'
group by year_month
order by year_month
```

In January 2023 we’ll be updating this data mart to include utilization (i.e. visits) with break outs of both spend and utilization by 16 different encounter types (e.g. acute inpatient, ED, office visit, SNF, etc.).

For information on data models and to view the entire DAG check out our dbt [Docs](https://tuva-health.github.io/pmpm/#!/overview).

## 🔌 What databases are supported?

This package has been tested on **Snowflake** , **Redshift** and **BigQuery**.

## 📚 What versions of dbt are supported?

This package requires you to have dbt installed and a functional dbt project running on dbt version `1.3.x`.

## ✅ How do I use this dbt package?

Below are the steps to run this individual dbt package.  To run all packages in The Tuva Project, please refer to this [README](https://github.com/tuva-health/the_tuva_project#readme).

### Overview

The Tuva Project is a collection of dbt packages that build healthcare concepts (measures, groupers, data quality tests) on top of your raw healthcare data. Each of these dbt packages expects you to have data in a certain format (specific tables with specific columns in them) and uses that as an input to then build healthcare concepts. To run any dbt package that is part of The Tuva Project, the basic idea is the same:

1. You create the necessary input tables as models within your dbt project so that the Tuva package of interest can reference them using ref() functions.
2. You import the Tuva package you are interested in and tell it where to find the relevant input tables as well as what database and schema to dump its output into.

### **Step 1:**

First you must create the necessary input tables as models within your dbt project so that the Tuva package of interest can reference them using ref() functions. To run this PMPM package, you must create [these 3 tables](https://tuva-health.github.io/pmpm/#!/model/model.pmpm_input.eligibility) as models within your dbt project.

### **Step 2:**

Once you have created the necessary 3 input tables as models within your dbt project, the next step is to import the PMPM package and tell it where to find the relevant input tables as well as what database and schema to dump its output into. These things are done by editing 2 different files in your dbt project: `packages.yml` and `dbt_project.yml`.

To import the PMPM package, you need to include the following in your `packages.yml`:

```
packages:
  - package: tuva-health/pmpm
    version: 0.0.2

```

To tell the PMPM package where to find the relevant input tables as well as what database and schema to dump its output into, you must add the following in your `dbt_project.yml:`

```
vars:
# These variables point to the 3 input table you created
# in your dbt project. The PMPM package will use
# these 3 table as input to build the Chronic Condition flags.
# If you named these 3 models anything other than 'medical_claim', 'eligibility',
# and 'pharmacy_claim' you must modify the refs here:
  medical_claim_override: "{{ref('medical_claim')}}"
  eligibility_override: "{{ref('eligibility')}}"
  pharmacy_claim_override: "{{ref('pharmacy_claim')}}"

# These variables name the database and schemas that the
# output of the PMPM package will be created in:
  tuva_database:  tuva     # make sure this database exists in your data warehouse
  pmpm_schema: pmpm

# By default, dbt prefixes schema names with the target
# schema in your profile. We recommend including this
# here so that dbt does not prefix the 'pmpm' schema
# with anything:
dispatch:
  - macro_namespace: dbt
    search_order: [ 'pmpm', 'dbt']

```

After completing the above steps you’re ready to run your project.

- Run dbt deps to install the package
- Run dbt build to run the entire project

You now have the chronic condition tables in your database and are ready to do analytics!

## 🙋🏻‍♀️ **How is this package maintained and how do I contribute?**

The Tuva Project team maintaining this package **only** maintains the latest version of the package. We highly recommend you stay consistent with the latest version.

Have an opinion on the mappings? Notice any bugs when installing and running the package? If so, we highly encourage and welcome feedback! While we work on a formal process in Github, we can be easily reached in our Slack community.

## 🤝 Join our community!

Join our growing community of healthcare data practitioners in [Slack](https://join.slack.com/t/thetuvaproject/shared_invite/zt-16iz61187-G522Mc2WGA2mHF57e0il0Q)!
