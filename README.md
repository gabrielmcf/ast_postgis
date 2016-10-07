Overview
========

This PostgreSQL extension implements advanced spatial data types and spatial integrity constraints.  The data types and constraints are those defined in the [OMT-G](http://homepages.dcc.ufmg.br/~clodoveu/DocuWiki/doku.php?id=omtg), an object-oriented data model for geographic applications. See below for more details.

Motivation
----------

Relational database management systems (RDBMS) were never designed since their concept to support spatial data. They were, nonetheless, expanded with modules that implement predicates, indexes structures and procedures that allow us store and manage spatial data. Such expansions, like PostGIS or Oracle Spatial, follow the standards defined by the OGC and are widely used by spatial database designers.

However, those expansions still do not offer all the necessary support to manager spatial data. Because their data types are usually semantically poor, nothing more then points, lines and polygons, and they do not implement spatial integrity constraints, which are different from those supported by relational databases as they make use of the spatial characteristics of the data. For instance, 'Gas stations cannot be 300 meters close to any school'.   

Therefore, this extension implements advanced spatial data types, integrity constraints procedures and consistency check functions to improve the design and consistency of spatial databases and, also, to reduce the gap between spatial conceptual models, which offer semantically rich data types and various integrity constraints, and the physical implementation on databases.


Compatibility
=============

This module has been tested on:

* **Postgres 9.5**
* **PostGIS 2.2**

And requires the extensions:

* **postgis**
* **postgis_topology**



Build and Install
=================

## From source ##

If you aren't using the `pg_config` on your path (or don't have it on your path), specify the correct one to build against:

        PG_CONFIG=/Library/PostgreSQL/9.5/bin/pg_config make

Or to build with what's on your path, just:

        make

Then install:

       sudo make install

After you've built and installed the artifacts, fire up `psql`:

      postgres=# CREATE EXTENSION ast_postgis;



Usage
=====

Here is explained how this extension works.


Advanced Spatial Data Types
---------------------------

The following table shows all the data types implemented by the extension and how they are mapped to the PostGIS types. The use of these data types generates automatic triggers to enforce topological and semantic integrity constraints.

<table>
   <thead>
      <th>Spatial Class</th>
      <th>Advanced spatial datatypes</th>
      <th>PostGIS Type</th>
   </thead>
   <tr>
      <td>Polygon</td>
      <td><code>ast_polygon</code></td>
      <td><code>geometry(polygon)</code></td>
   </tr>
   <tr>
      <td>Line</td>
      <td><code>ast_line</code></td>
      <td><code>geometry(linestring)</code></td>
   </tr>
   <tr>
      <td>Point</td>
      <td><code>ast_point</code></td>
      <td><code>geometry(point)</code></td>
   </tr>
   <tr>
      <td>Node</td>
      <td><code>ast_node</code></td>
      <td><code>geometry(point)</code></td>
   </tr>
   <tr>
      <td>Isoline</td>
      <td><code>ast_isoline</code></td>
      <td><code>geometry(linestring)</code></td>
   </tr>
   <tr>
      <td>Planar subdivision</td>
      <td><code>ast_planarsubdivision</code></td>
      <td><code>geometry(polygon)</code></td>
   </tr>
   <tr>
      <td>Triangular Irregular Network (TIN)</td>
      <td><code>ast_tin</code></td>
      <td><code>geometry(polygon)</code></td>
   </tr>
   <tr>
      <td>Tesselation</td>
      <td><code>ast_tesselation</code></td>
      <td><code>raster</code></td>
   </tr>
   <tr>
      <td>Sample</td>
      <td><code>ast_sample</code></td>
      <td><code>geometry(point)</code></td>
   </tr>
   <tr>
      <td>Unidirectional line</td>
      <td><code>ast_uniline</code></td>
      <td><code>geometry(linestring)</code></td>
   </tr>
   <tr>
      <td>Bidirectional line</td>
      <td><code>ast_biline</code></td>
      <td><code>geometry(linestring)</code></td>
   </tr>
</table>


Trigger procedures for relationship integrity constraints
---------------------------------------------------------

The following procedures can be called by triggers to assert the consistency of spatial relationships, like topological relationship, arc-node and arc-arc networks or spatial aggregation.

<table>
   <thead>
      <th>Spatial Relationship</th>
      <th>Trigger Procedure</th>
   </thead>
   <tr>
      <td>Topological Relationship</td>
      <td><code>ast_topologicalrelationship(a_tbl, a_geom, b_tbl, b_geom, spatial_relation)</code></td>
   </tr>
   <tr>
      <td>Topological Relationship (near)</td>
      <td><code>ast_topologicalrelationship(a_tbl, a_geom, b_tbl, b_geom, distance)</code></td>
   </tr>
   <tr>
      <td>Arc-Node Network</td>
      <td><code>ast_arcnodenetwork(arc_tbl, arc_geom, node_tbl, node_geom)</code></td>
   </tr>
   <tr>
      <td>Arc-Arc Network</td>
      <td><code>ast_arcnodenetwork(arc_tbl, arc_geom)</code></td>
   </tr>
   <tr>
      <td>Spatial Aggregation</td>
      <td><code>ast_aggregation(part_tbl, part_geom, whole_tbl, whole_geom)</code></td>
   </tr>
</table>

The `spatial_relation` argument, which are passed as an argument to the topological relationship procedure, can be one of the following:

* contains
* containsproperly
* covers
* coveredby
* crosses
* disjoint
* intersects
* overlaps
* touches
* within


Consistency check functions
---------------------------

The SQL functions listed in this section can be called to analyze the consistency of the spatial database. These functions return the state of the database (`true` = valid, `false` = invalid) and register, in the `ast_validation_log` table, the details of each inconsistency encountered.

<table>
   <thead>
      <th>Spatial Relationship</th>
      <th>Check functions</th>
   </thead>
   <tr>
      <td>Topological Relationship</td>
      <td><code>ast_isTopologicalRelationshipValid(a_tbl text, a_geom text, b_tbl text, b_geom text, dist real)</code></td>
   </tr>
   <tr>
      <td>Topological Relationship (near)</td>
      <td><code>ast_isTopologicalRelationshipValid(a_tbl text, a_geom text, b_tbl text, b_geom text, relation text)</code></td>
   </tr>
   <tr>
      <td>Arc-Node Network</td>
      <td><code>ast_isNetworkValid(arc_tbl text, arc_geom text, node_tbl text, node_geom text)</code></td>
   </tr>
   <tr>
      <td>Arc-Arc Network</td>
      <td><code>ast_isNetworkValid(arc_tbl text, arc_geom text)</code></td>
   </tr>
   <tr>
      <td>Spatial Aggregation</td>
      <td><code>ast_isSpatialAggregationValid(part_tbl text, part_geom text, whole_tbl text, whole_geom text)</code></td>
   </tr>
</table>


Use Case
========

This section shows an use case example (also available in the `examples` folder) intended to clarify the use of this extension.

Transportation system
---------------------

The following figure shows a schema fragment for a bus transportation network (nodes at bus stops and unidirectional arcs corresponding to route segments) that serves a set of school districts. A conventional class holds the attributes for the bus line. The schema embeds spatial integrity constraints for (1) the network relationship (each route segment must be related to two bus stops), (2) a “contains” relationship (school district cannot exists without a bus stop), and (3) the geometry of route segments and school districts (lines and polygons must be simple, i.e., with no self-intersections).

<img src="https://github.com/lizardoluis/ast_postgis/blob/master/examples/transportation_system/squema.png" alt="Transportation system schema" width="50%">

The implementation of this schema that uses the `ast_postgis` extension and considerers all the spatial constraints is as follows:

      create table bus_line (
         line_number integer primary key,
         description varchar(50),
         operator varchar(50)
      );

      create table school_district (
         district_name varchar(50) primary key,
         school_capacity integer,
         geom ast_polygon
      );

      create table bus_stop (
         stop_id integer primary key,
         shelter_type varchar(50),
         geom ast_point
      );

      create table bus_route_segment (
         traverse_time real,
         segment_number integer,
         busline integer references bus_line (line_number),
         geom ast_uniline
      );

      -- school_district and bus_stop topological relationship constraints:
      create trigger school_district_contains_trigger
         after insert or update on school_district
         for each statement
         execute procedure ast_topologicalrelationship('school_district', 'geom', 'bus_stop', 'geom', 'contains');

      --bus_route_segment and bus_stop arc-node network constraints:
      create trigger busroute_insert_update_trigger
         after insert or update on bus_route_segment
      	for each statement
      	execute procedure ast_arcnodenetwork('bus_route_segment', 'geom', 'bus_stop', 'geom');


License and Copyright
=====================

ast_postgis is released under a [MIT license](doc/LICENSE).

Copyright (c) 2016 Luis Eduardo Oliveira Lizardo.
